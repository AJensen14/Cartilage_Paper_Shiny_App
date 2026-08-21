# global

library(shiny)
library(DT)
library(plotly)
library(dplyr)
library(tidyr)
library(readr)

# -------------------------------------------------------------
# 1. FILE PATHS -- edit these to match your actual file names
# -------------------------------------------------------------
PATHS <- list(
  age_de   = "www/data/Cartilage_DA_results.csv",
  sex_de   = "www/data/Cartilage_DA_results_sex.csv",
  norm     = "www/data/Cartilage_normalised_data.csv",
  metadata = "www/data/cartilage_matrix.csv"
)

# -------------------------------------------------------------
# 2. COLUMN NAMES -- edit these ONCE and the whole app updates.
#    Current values are guesses based on limma-style output.
# -------------------------------------------------------------
DE_COLS <- list(
  protein = "X",     # protein accession / ID column in the DE results
  logfc   = "logFC",       # log2 fold change
  pval    = "P.Value",     # raw p-value
  adjp    = "adj.P.Val"    # adjusted p-value (FDR)
)

META_COLS <- list(
  sample    = "sample_ID",    # sample ID -- must match the column names of the normalised data
  age_group = "age", # e.g. "Young" / "Old"
  sex       = "Sex",       # e.g. "F" / "M"
  age       = "age_years"        # age in years
)

MISSING_MSG <- "Data file not found -- check the file names in PATHS at the top of global.R."

# -------------------------------------------------------------
# 3. DATA LOADING (app still runs if a file is missing;
#    the relevant page just shows a message instead)
# -------------------------------------------------------------
safe_read <- function(path) {
  if (file.exists(path)) {
    readr::read_csv(path, show_col_types = FALSE)
  } else {
    message("File not found (app will still run): ", path)
    NULL
  }
}

age_de   <- safe_read(PATHS$age_de)
sex_de   <- safe_read(PATHS$sex_de)
norm_dat <- safe_read(PATHS$norm)
metadata <- safe_read(PATHS$metadata)

# Long-format normalised data joined to the metadata, used for the
# per-protein boxplots. Assumes the FIRST column of the normalised
# data is the protein ID and the remaining columns are samples.
norm_long <- NULL
if (!is.null(norm_dat) && !is.null(metadata)) {
  id_col <- names(norm_dat)[1]
  norm_long <- norm_dat %>%
    pivot_longer(-all_of(id_col), names_to = "SampleID", values_to = "Abundance") %>%
    rename(ProteinID = all_of(id_col)) %>%
    left_join(metadata, by = setNames(META_COLS$sample, "SampleID"))
}

# -------------------------------------------------------------
# 4. Small plotly helpers (dotted threshold lines on the volcano)
# -------------------------------------------------------------
vline <- function(x, colour = "#8a8a8a") {
  list(type = "line", x0 = x, x1 = x, y0 = 0, y1 = 1, yref = "paper",
       line = list(dash = "dot", color = colour, width = 1))
}
hline <- function(y, colour = "#8a8a8a") {
  list(type = "line", y0 = y, y1 = y, x0 = 0, x1 = 1, xref = "paper",
       line = list(dash = "dot", color = colour, width = 1))
}

# =============================================================
# 5. MODULE: differential abundance results page
#    Used twice (Age page and Sex page) so the code lives once.
# =============================================================

deResultsUI <- function(id) {
  ns <- NS(id)
  fluidRow(
    column(3,
           wellPanel(class = "de-sidebar",
                     h4("Significance thresholds"),
                     
                     sliderInput(ns("p_cut"), "P-value cut-off",
                                 min = 0.001, max = 0.10, value = 0.05, step = 0.001),
                     
                     radioButtons(
                       ns("p_type"),
                       "P-value type",
                       choices = c(
                         "Adjusted p-value (FDR)" = "adjp",
                         "Raw p-value" = "pval"
                       ),
                       selected = "adjp"
                     ),
                     
                     sliderInput(ns("fc_cut"), "Absolute log2 fold change cut-off",
                                 min = 0, max = 3, value = 1, step = 0.1),
                     
                     uiOutput(ns("sig_summary")),
                     
                     hr(),
                     
                     h4("Plot a protein"),
                     selectizeInput(ns("protein"), "Protein", choices = NULL,
                                    options = list(placeholder = "Type to search..."))
           )
    ),
    column(9,
           tabsetPanel(
             tabPanel("Volcano plot",
                      plotlyOutput(ns("volcano"), height = "520px")),
             tabPanel("Results table",
                      br(), DTOutput(ns("table"))),
             tabPanel("Protein abundance",
                      br(),
                      p(class = "help-text",
                        "Normalised abundance of the protein selected on the left, split by group."),
                      plotlyOutput(ns("boxplot"), height = "460px"))
           )
    )
  )
}

deResultsServer <- function(id, de_data, group_col) {
  moduleServer(id, function(input, output, session) {
    
    # Populate the protein search box (server-side = fast for 1000s of proteins)
    observe({
      req(de_data)
      updateSelectizeInput(session, "protein",
                           choices = sort(unique(de_data[[DE_COLS$protein]])),
                           server = TRUE)
    })
    
    # DE results with -log10(p) and an Up / Down / NS status flag
    results <- reactive({
      req(de_data)
      
      # Choose which p-value column to use
      p_col <- if (input$p_type == "pval") {
        DE_COLS$pval
      } else {
        DE_COLS$adjp
      }
      
      de_data %>%
        mutate(
          PValueUsed = .data[[p_col]],
          negLog10P = -log10(PValueUsed),
          
          Status = factor(
            case_when(
              PValueUsed < input$p_cut &
                .data[[DE_COLS$logfc]] >= input$fc_cut ~ "Up",
              
              PValueUsed < input$p_cut &
                .data[[DE_COLS$logfc]] <= -input$fc_cut ~ "Down",
              
              TRUE ~ "Not significant"
            ),
            levels = c("Down", "Not significant", "Up")
          )
        )
    })
    
    output$sig_summary <- renderUI({
      req(de_data)
      d <- results()
      tagList(
        div(class = "sig-box sig-up",   paste0(sum(d$Status == "Up"),   " more abundant")),
        div(class = "sig-box sig-down", paste0(sum(d$Status == "Down"), " less abundant"))
      )
    })
    
    output$volcano <- renderPlotly({
      validate(need(!is.null(de_data), MISSING_MSG))
      d <- results()
      plot_ly(
        x = d[[DE_COLS$logfc]],
        y = d$negLog10P,
        text = d[[DE_COLS$protein]],
        color = d$Status,
        colors = c("Down" = "#3b7dd8", "Not significant" = "#c9ced1", "Up" = "#d84b3b"),
        type = "scatter", mode = "markers",
        marker = list(size = 7, opacity = 0.75),
        hovertemplate = "%{text}<br>log2FC: %{x:.2f}<br>-log10 p-value: %{y:.2f}<extra></extra>"
      ) %>%
        layout(
          xaxis = list(title = "log2 fold change", zeroline = FALSE),
          yaxis = list(
            title = if (input$p_type == "pval")
              "-log10 p-value"
            else
              "-log10 adjusted p-value"
          ),
          legend = list(orientation = "h", x = 0, y = 1.08),
          shapes = list(vline(input$fc_cut), vline(-input$fc_cut),
                        hline(-log10(input$p_cut)))
        )
    })
    
    output$table <- renderDT({
      validate(need(!is.null(de_data), MISSING_MSG))
      
      d <- results() %>%
        arrange(.data[[DE_COLS$adjp]]) %>%
        select(-negLog10P, -PValueUsed)
      
      numeric_cols <- names(d)[sapply(d, is.numeric)]
      
      datatable(
        d,
        rownames = FALSE,
        filter = "top",
        extensions = "Buttons",
        options = list(
          pageLength = 15,
          scrollX = TRUE,
          dom = "Bfrtip",
          buttons = c("copy", "csv")
        ),
        class = "stripe hover"
      ) %>%
        formatSignif(columns = numeric_cols, digits = 3)
    })
    
    output$boxplot <- renderPlotly({
      validate(
        need(!is.null(norm_long),
             "Normalised data and/or metadata not loaded -- check PATHS in global.R."),
        need(nzchar(input$protein), "Choose a protein from the dropdown on the left.")
      )
      d <- norm_long %>% filter(ProteinID == input$protein)
      validate(
        need(nrow(d) > 0,
             "Protein not found in the normalised data (do the IDs match the DE results?)."),
        need(group_col %in% names(d),
             paste0("Column '", group_col, "' not found in the metadata -- check META_COLS in global.R."))
      )
      plot_ly(
        x = d[[group_col]],
        y = d$Abundance,
        color = d[[group_col]],
        type = "box",
        boxpoints = "all", jitter = 0.4, pointpos = 0,
        text = d$SampleID,
        hovertemplate = "%{text}<br>Abundance: %{y:.2f}<extra></extra>"
      ) %>%
        layout(
          xaxis = list(
            title = "log2 fold change",
            zeroline = FALSE
          ),
          yaxis = list(
            title = if (input$p_type == "pval")
              "-log10 p-value"
            else
              "-log10 adjusted p-value"
          ),
          legend = list(
            orientation = "h",
            x = 0,
            y = 1.08
          ),
          shapes = list(
            vline(input$fc_cut),
            vline(-input$fc_cut),
            hline(-log10(input$p_cut))
          )
        )
    })
  })
}