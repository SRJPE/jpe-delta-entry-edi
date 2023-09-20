library(tidyverse)
library(readxl)

# catch
catch_raw <- read_xlsx(here::here("data-raw", "DeltaEntry_CatchRaw.xlsx")) |>
  mutate(atCaptureRun = if_else(atCaptureRun == "Not applicable (n/a)", NA_character_, atCaptureRun)) |>
  glimpse()

write_csv(catch_raw, here::here("data", "delta_entry_catch_edi.csv"))

# trap
trap_raw <- read_xlsx(here::here("data-raw", "DeltaEntry_TrapRaw.xlsx")) |>
  glimpse()

write_csv(trap_raw, here::here("data", "delta_entry_trap_edi.csv"))

# recaptures empty due to no recaptures and missing data
recaptures_raw <- read_xlsx(here::here("data-raw", "DeltaEntry_RecapturesRaw.xlsx")) |>
  glimpse()

write_csv(recaptures_raw, here::here("data", "delta_entry_recapture_edi.csv"))

# release
release_raw <- read_xlsx(here::here("data-raw", "DeltaEntry_ReleaseRaw.xlsx")) |>
  glimpse()
write_csv(release_raw, here::here("data", "delta_entry_release_edi.csv"))

# releasefish empty bc of no recaptures and missing data
releasefish_raw <- read_xlsx(here::here("data-raw", "DeltaEntry_ReleaseFishRaw.xlsx")) |>
  glimpse()



# look at clean data ------------------------------------------------------

catch <- read_csv(here::here("data", "delta_entry_catch_edi.csv")) |> glimpse()
trap <- read_csv(here::here("data", "delta_entry_trap_edi.csv")) |> glimpse()
recaptures <- read_csv(here::here("data", "delta_entry_recapture_edi.csv")) |> glimpse()
release <- read_csv(here::here("data", "delta_entry_release_edi.csv")) |> glimpse()


