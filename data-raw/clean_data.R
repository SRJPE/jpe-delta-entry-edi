library(tidyverse)
library(readxl)

# catch
# TODO actualCount is all "Yes"
# TODO difference between atCaptureRun and finalRun
catch_raw <- read_xlsx(here::here("data-raw", "DeltaEntry_CatchRaw.xlsx")) |>
  mutate(atCaptureRun = if_else(atCaptureRun == "Not applicable (n/a)", NA_character_, atCaptureRun)) |>
  glimpse()

write_csv(catch_raw, here::here("data", "catch.csv"))

# trap
# TODO do we want counterAtStart?
trap_raw <- read_xlsx(here::here("data-raw", "DeltaEntry_TrapRaw.xlsx")) |>
  glimpse()

write_csv(trap_raw, here::here("data", "trap.csv"))

# recaptures empty due to no recaptures and missing data
recaptures_raw <- read_xlsx(here::here("data-raw", "DeltaEntry_RecapturesRaw.xlsx")) |>
  select(-mort) |>
  glimpse()

write_csv(recaptures_raw, here::here("data", "recaptures.csv"))

# release
# TODO sourceOFFishSite, releaseSubSite, and appliedMarkCode are NA
# TODO what is testDays?
release_raw <- read_xlsx(here::here("data-raw", "DeltaEntry_ReleaseRaw.xlsx")) |>
  select(-c(sourceOfFishSite, appliedMarkCode)) |>
  glimpse()
write_csv(release_raw, here::here("data", "release.csv"))

# releasefish empty bc of no recaptures and missing data
releasefish_raw <- read_xlsx(here::here("data-raw", "DeltaEntry_ReleaseFishRaw.xlsx")) |>
  glimpse()



# look at clean data ------------------------------------------------------

catch <- read_csv(here::here("data", "catch.csv")) |> glimpse()
trap <- read_csv(here::here("data", "trap.csv")) |> glimpse()
recaptures <- read_csv(here::here("data", "recaptures.csv")) |> glimpse()
release <- read_csv(here::here("data", "release.csv")) |> glimpse()

