# UI
ui <- navbarPage(
  
  title = "caRtilage",
  windowTitle = "caRtilage | Equine cartilage proteomics",
  id = "main_nav",
  collapsible = TRUE,
  
  header = tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles/styles.css")
  ),
  
  # ------------------------------ HOME ------------------------------
  tabPanel("Home",
           div(class = "page-container",
               
               div(class = "hero",
                   h1("caRtilage"),
                   p(class = "hero-subtitle",
                     "Proteomic profiling of ageing in equine articular cartilage")
               ),
               
               uiOutput("home_stats"),
               
               div(class = "content-section",
                   h2("About the project"),
                   p("Osteoarthritis is a leading cause of equine lameness and ageing is a major risk factor for disease development. 
                   However, the molecular changes occurring in healthy ageing cartilage remain incompletely characterised. 
                   This study used high-resolution proteomics to define age-related alterations in the equine cartilage proteome.  
                   In this study we used label-free mass spectrometry to profile 
                   the cartilage proteome of ten horses:
                   young animals (3\u20135 years) and old animals (15+ years)."),
                   
                   
                   p(
                     "This research was done in association with the Equine Ageing Protein Atlas, a project funded by the Horserace Betting Levy Board. ",
                     "The full protein atlas can be found by ",
                     a("clicking here", href = "https://andersjensen14.shinyapps.io/equineproteinatlas/", target = "_blank")
                   )
                   
                   ),
               
               div(class = "content-section",
                   h2("What you can explore in this app"),
                   tags$ul(
                     tags$li(strong("Methods"), " \u2013 how samples were collected and processed,
                   plus the full sample metadata."),
                     tags$li(strong("Age"), " \u2013 differential protein abundance between
                   young (3\u20135 yrs) and old (15+ yrs) cartilage."),
                     tags$li(strong("Sex"), " \u2013 the same analysis comparing male and
                   female animals."),
                     tags$li(strong("Contact"), " \u2013 who we are and how to get in touch.")
                   )
               )
           )
  ),
  
  # ----------------------------- METHODS -----------------------------
  tabPanel("Methods",
           div(class = "page-container",
               h1("Methods"),
               
               div(class = "content-section",
                   h2("Sample collection"),
                   p("Samples were collected as a byproduct of the agricultural industry. 
                     Specifically, the Animal (Scientific Procedures) Act 1986, Schedule 2, 
                     does not define collection from these sources as scientific procedures. 
                     Ethical approval was therefore not required for this study. 
                     Full-thickness equine (all Thoroughbreds) cartilage from the entire surface of 
                     macroscopically healthy metacarpophalangeal joints was collected from an abattoir. 
                     Ten samples per age group; young (3-5 years) and old (18-25 years) were processed.
                     Macroscopic scoring of the metacarpophalangeal joing was undertaken to exclude horses 
                     with clear signs of wear/injury.")
               ),
               div(class = "content-section",
                   h2("Protein extraction"),
                   p("For proteomic analysis, proteins were extracted from lyophilised cartilage tissue using a guanidine hydrochloride (GdnHCl) 
                   (ThermoFisher Scientific, Massachusetts, USA) based extraction protocol adapted for extracellular matrix-rich tissues. 
                   Briefly, 50 mg of lyophilised cartilage powder generated from pulverised frozen tissue was suspended in 0.5 mL extraction 
                   buffer containing 4 M GdnHCl, 65 mM dithiothreitol  and 50 mM sodium acetate (pH 6.0) (all ThermoFisher Scientific, Massachusetts, USA) 
                   Samples were incubated under end-over-end mixing for 20 h at 4°C to facilitate solubilisation of cartilage ECM proteins. 
                   Following extraction, samples were centrifuged at 13,000 × g for 15 min at 4°C, and the soluble protein-containing supernatant was collected. 
                   To remove GdnHCl prior to downstream proteomic processing, supernatants were subjected to buffer exchange using 3 kDa molecular weight cut-off 
                   centrifugal filters (Amicon Ultra, Merck Millipore, Gillingham, UK). Aliquots of the extract were centrifuged at 14,000 × g for 10–15 min at 4°C and the flow-through 
                   discarded. Retained proteins were washed with 400 μL urea buffer (8 M urea, 50 mM Tris-HCl, pH 8.0) (ThermoFisher Scientific, Massachusetts, USA), with the buffer 
                   exchange repeated three times to ensure removal of residual chaotrope. Proteins retained on the filter were recovered for subsequent analysis. 
                   Protein concentration was determined using the Pierce™ 660 nm Protein Assay (ThermoFisher Scientific, Massachusetts, USA) according to the manufacturer's instructions, 
                   using bovine serum albumin standards for calibration. Absorbance was measured at 660 nm using a SPECTROstar Nano plate reader 
                   (BMG Labtech, Ortenburg, Germany) and protein quantification was calculated using R (version 4.2.2).")
               ),
               div(class = "content-section",
                   h2("Protein Digestion"),
                   p("The protein-containing supernatants (50ug) were diluted with 25mM ammonium bicarbonate (Sigma-Aldrich, Missouri, USA), 
                     then reduced and alkylated using DTT and IAA respectively. Following incubation for 30 min in darkness, 6 µl of 20 ng/µl 
                     Carboxylate-Modified Particles Magnetic SpeedBeads Sera-Mag™ (Cytiva,Massachusetts, USA) were added with 360µl of 100% ethanol 
                     (Fisher Scientific, New Hampshite, USA). Samples were washed three times with 80% ethanol with a MagRack™ 6 (Cytiva,Massachusetts, USA) 
                     rack and incubated overnight at 37°C with 110µl of 0.01µg/mL Trypsin/Lys-C (Promega, Wisconsin, USA). 
                     Peptides were eluted the following day and acidification completed with the addition of 1µl of trifluoroacetic Acid 
                     (ThermoFisher, Massachusetts, USA).")
               ),
               div(class = "content-section",
                   h2("Mass spectrometry"),
                   p("Dried peptides were reconstituted in 0.1% formic acid (FA) in LC-MS-grade water and sonicated for 5 min. 
                     Following centrifugation (13,000 × g, 10 min, 4°C), the supernatant was collected. Peptides (250 ng) were 
                     loaded onto Evotips (EV-2011, Evosep Biosystems, Denmark) conditioned with isopropanol and equilibrated with 
                     0.1% FA-containing solvents according to the manufacturer's instructions. After peptide loading and washing with 
                     0.1% FA in water, tips were stored in 100 μL of 0.1% FA until LC-MS/MS analysis. Peptide separation and analysis 
                     were performed using an Evosep One nano-LC platform (Evosep Biosystems, Odense, Denmark) coupled directly to a timsTOF HT mass spectrometer 
                     (Bruker Daltonics, Bremen, Germany), featuring trapped ion mobility spectrometry–quadrupole time-of-flight (TIMS-QTOF) technology and a 
                     CaptiveSpray nano-electrospray ion source. Chromatographic separation was achieved on a PepSep C18 reversed-phase analytical column 
                     (15 cm × 150 μm, 1.5 μm particle size; Bruker Daltonics) using the Evosep 30 samples-per-day method, corresponding to a 44 min gradient. 
                     Data-independent acquisition was undertaken using the dia-PASEF workflow. The acquisition method covered an m/z range of 475–1200 and an 
                     ion mobility range of 1/K₀ = 0.60–1.60 Vs/cm². Ion accumulation and mobility ramp times were both set to 100 ms within the dual TIMS device. 
                     Collision energy was applied in a mobility-dependent manner, decreasing linearly from 59 eV at 1/K₀ = 1.6 Vs/cm² to 20 eV at 1/K₀ = 0.6 Vs/cm². 
                     The dia-PASEF acquisition scheme employed 32 sequential isolation windows, each spanning 26 m/z, without overlap between adjacent mass windows 
                     and incorporating a single mobility window. This configuration yielded an estimated duty cycle of approximately 1.8 s.")
               ),
               div(class = "content-section",
                   h2("Data processing & statistics"),
                   p("Raw DIA datasets were processed using Spectronaut DirectDIA+ v19.4 (Biognosys, Switzerland) and searched against 
                     the Equus caballus UniProt proteome database (21,429 entries; downloaded 7 March 2024). Searches employed Trypsin/P 
                     digestion with up to two missed cleavages, carbamidomethylated cysteine as a fixed modification, and methionine oxidation 
                     and N-terminal acetylation as variable modifications. Peptide and protein identifications were filtered at a 1% FDR (q-value ≤ 0.01). 
                     Quantitative analysis was performed at the MS2 level with local normalisation applied across all samples.")
               ),
               
               div(class = "content-section",
                   h2("Raw data upload"),
                   p("The mass spectrometry data have been deposited to the ProteomeXchange Consortium via the PRIDE partner repository
                     with the dataset identifier xxxxxxxxxx")
               ),
               
               div(class = "content-section",
                   h2("Sample metadata"),
                   p("The ten animals included in the study:"),
                   DTOutput("metadata_table")
               )
           )
  ),
  
  # ------------------------------- AGE -------------------------------
  tabPanel("Age",
           div(class = "page-container",
               h1("Differential abundance \u2014 age"),
               p(class = "page-intro",
                 "Old (15+ years) versus young (3\u20135 years) cartilage. Positive log2
         fold changes indicate higher abundance in the old group. Adjust
         the thresholds on the left; the volcano plot, table and counts update
         together."),
               deResultsUI("age")
           )
  ),
  
  # ------------------------------- SEX -------------------------------
  tabPanel("Sex",
           div(class = "page-container",
               h1("Differential abundance \u2014 sex"),
               p(class = "page-intro",
                 "Comparison of male and female animals. Positive log2 fold changes
         indicate higher abundance in male horses. Adjust the thresholds on the left; the volcano plot,
         table and counts update together."),
               deResultsUI("sex")
           )
  ),
  
  # ----------------------------- CONTACT -----------------------------
  tabPanel("Contact",
           div(class = "page-container",
               h1("Contact"),
               div(class = "content-section contact-card",
                   h3("Anders Jensen"),
                   p("Post-doctoral Researcher"),
                   p("Department of Musculoskeletal and Ageing Science, University of Liverpool, William Henry Duncan Building, 6, West Derby Street, Liverpool"),
                   p(strong("Email: "),
                     tags$a(href = "mailto:jensen14@liverpool.ac.uk", "jensen14@liverpool.ac.uk")),
                   p(strong("Github: "), 
                     a("https://github.com/AJensen14", href = "https://github.com/AJensen14", target = "_blank")),
                   p(strong("LinkedIn: "), 
                     a("https://www.linkedin.com/in/anders-jensen-296219324/", href = "https://www.linkedin.com/in/anders-jensen-296219324/", target = "_blank"))
               ),
               div(class = "content-section contact-card",
                   h3("Mandy Peffers"),
                   p("Project Supervisor"),
                   p('Department of Musculoskeletal and Ageing Science, University of Liverpool, William Henry Duncan Building, 6, West Derby Street, Liverpool'),
                   p(strong("Email: "),
                     tags$a(href = "mailto:peffs@liverpool.ac.uk", "peffs@liverpool.ac.uk")),
                   p(strong("Links: "), 
                     a("Lab group", href = "https://www.liverpool.ac.uk/people/mandy-peffers", target = "_blank"))
               ),
               div(class = "content-section contact-card",
                   h3("Kareena Adair"),
                   p("Proteomics"),
                   p("Centre for Proteome Research, Institute of Systems, Molecular and Integrative Biology, 
                     University of Liverpool, Biosciences Building, Crown Street, Liverpool"),
               ),
               div(class = "content-section contact-card",
                   h3("Guido Rocchigiani"),
                   p("Sample processing and pathology"),
                   p("Vet Anatomy, Physiology and Pathology, Institute of Infection, Veterinary and Ecological Sciences, University of Liverpool, Leahurst Campus, Neston, UK"),
               ),
               div(class = "content-section contact-card",
                   h3("Ufuk Ersoy"),
                   p("Data analysis"),
                   p("Department of Musculoskeletal and Ageing Science, University of Liverpool, William Henry Duncan Building, 6, West Derby Street, Liverpool"),
               ),
               div(class = "content-section contact-card",
                   h3("Federico Foti"),
                   p("Sample Processing"),
                   p("Institute of Infection, Veterinary and Ecological Sciences, Liverpool L69 7ZX"),
               ),
               div(class = "content-section contact-card",
                   h3("Min Xue"),
                   p("Sample Processing"),
                   p("Min"),
               ),
               div(class = "content-section contact-card",
                   h3("Mayane Levy"),
                   p("Student researcher"),
                   p("Mayane"),
               ),
               div(class = "content-section contact-card",
                   h3("Georgia McMullen"),
                   p("Student researcher"),
                   p("Department of Musculoskeletal and Ageing Science, University of Liverpool, William Henry Duncan Building, 6, West Derby Street, Liverpool"),
               ),
               div(class = "content-section contact-card",
                   h3("Yolanda Dong"),
                   p("Student researcher"),
                   p("Yolanda"),
               )
           )
  )
)
