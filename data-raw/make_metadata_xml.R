library(EDIutils)
library(tidyverse)
library(tidyverse)
library(readxl)
library(EML)
library(EMLaide)

datatable_metadata <-
  dplyr::tibble(filepath = c("data/delta_entry_catch_edi.csv",
                             "data/delta_entry_trap_edi.csv",
                             ##"data/delta_entry_recapture_edi.csv",
                             "data/delta_entry_release_edi.csv"),
                attribute_info = c("data-raw/metadata/delta_entry_catch_metadata.xlsx",
                                   "data-raw/metadata/delta_entry_trap_metadata.xlsx",
                                   #"data-raw/metadata/delta_entry_recapture_metadata.xlsx",
                                   "data-raw/metadata/delta_entry_release_metadata.xlsx"),
                datatable_description = c("Daily catch",
                                          "Daily trap operations",
                                          #"Recaptured fish",
                                          "Released fish"),
                datatable_url = paste0("https://raw.githubusercontent.com/SRJPE/jpe-delta-entry-edi/main/data/",
                                       c("delta_entry_catch_edi.csv",
                                         "delta_entry_trap_edi.csv",
                                         #"delta_entry_recapture_edi.csv",
                                         "delta_entry_release_edi.csv")))

excel_path <- "data-raw/metadata/delta_entry_metadata.xlsx"
sheets <- readxl::excel_sheets(excel_path)
metadata <- lapply(sheets, function(x) readxl::read_excel(excel_path, sheet = x))
names(metadata) <- sheets

abstract_docx <- "data-raw/metadata/abstract.docx"
methods_docx <- "data-raw/metadata/methods.md" # original, bulleted methods are in the .docx file

#edi_number <- reserve_edi_id(user_id = Sys.getenv("edi_user_id"), password = Sys.getenv("edi_password"))
edi_number <- "edi.1503.1" # reserved 9-20-2023 under srjpe account

dataset <- list() %>%
  add_pub_date() %>%
  add_title(metadata$title) %>%
  add_personnel(metadata$personnel) %>%
  add_keyword_set(metadata$keyword_set) %>%
  add_abstract(abstract_docx) %>%
  add_license(metadata$license) %>%
  add_method(methods_docx) %>%
  add_maintenance(metadata$maintenance) %>%
  add_project(metadata$funding) %>%
  add_coverage(metadata$coverage, metadata$taxonomic_coverage) %>%
  add_datatable(datatable_metadata)

# GO through and check on all units
custom_units <- data.frame(id = c("number of rotations", "NTU", "revolutions per minute", "number of fish", "days",
                                  "see waterTempUnit", "microSiemensPerCentimeter", "percentage"),
                           unitType = c("dimensionless", "dimensionless", "dimensionless", "dimensionless",
                                        "dimensionless", "dimensionless","dimensionless", "dimensionless"),
                           parentSI = c(NA, NA, NA, NA, NA, NA, NA, NA),
                           multiplierToSI = c(NA, NA, NA, NA, NA, NA, NA, NA),
                           description = c("number of rotations",
                                           "nephelometric turbidity units, common unit for measuring turbidity",
                                           "number of revolutions per minute",
                                           "number of fish counted",
                                           "number of days",
                                           "see designated column for units of water temperature collected",
                                           "units for measuring conductivity",
                                           "units for measuring dissolved oxygen content"))


unitList <- EML::set_unitList(custom_units)

eml <- list(packageId = edi_number,
            system = "EDI",
            access = add_access(),
            dataset = dataset,
            additionalMetadata = list(metadata = list(unitList = unitList))
)
edi_number
EML::write_eml(eml, paste0(edi_number, ".xml"))
EML::eml_validate(paste0(edi_number, ".xml"))

EMLaide::evaluate_edi_package(Sys.getenv("edi_user_id"), Sys.getenv("edi_password"), paste0(edi_number, ".xml"))
View(report_df)
EMLaide::upload_edi_package(Sys.getenv("edi_user_id"), Sys.getenv("edi_password"), paste0(edi_number, ".xml"))



# preview_coverage <- function(dataset) {
#   coords <- dataset$coverage$geographicCoverage$boundingCoordinates
#   north <- coords$northBoundingCoordinate
#   south <- coords$southBoundingCoordinate
#   east <- coords$eastBoundingCoordinate
#   west <- coords$westBoundingCoordinate
#
#   leaflet::leaflet() |>
#     leaflet::addTiles() |>
#     leaflet::addRectangles(
#       lng1 = west, lat1 = south,
#       lng2 = east, lat2 = north,
#       fillColor = "blue"
#     )
# }
preview_coverage(dataset)
