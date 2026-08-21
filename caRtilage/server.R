# Server
server <- function(input, output, session) {
  
  # ---------------- Home: summary stat cards ----------------
  output$home_stats <- renderUI({
    n_samples  <- if (!is.null(metadata)) nrow(metadata) else 10
    n_proteins <- if (!is.null(norm_dat)) nrow(norm_dat) else "\u2014"
    n_age_sig  <- if (!is.null(age_de)) {
      sum(age_de[[DE_COLS$adjp]] < 0.05, na.rm = TRUE)
    } else "\u2014"
    
    fluidRow(
      column(4, div(class = "stat-card",
                    div(class = "stat-number", n_samples),
                    div(class = "stat-label", "Cartilage samples")
      )),
      column(4, div(class = "stat-card",
                    div(class = "stat-number", n_proteins),
                    div(class = "stat-label", "Proteins quantified")
      )),
      column(4, div(class = "stat-card",
                    div(class = "stat-number", n_age_sig),
                    div(class = "stat-label", "Age-associated proteins (adj. p < 0.05)")
      ))
    )
  })
  
  # ---------------- Methods: metadata table ----------------
  output$metadata_table <- renderDT({
    validate(need(!is.null(metadata), MISSING_MSG))
    datatable(
      metadata,
      rownames = FALSE,
      filter = "top",
      options = list(pageLength = 10, scrollX = TRUE),
      class = "stripe hover"
    )
  })
  
  # ---------------- Age & Sex pages (module) ----------------
  deResultsServer("age", age_de, META_COLS$age_group)
  deResultsServer("sex", sex_de, META_COLS$sex)
}
