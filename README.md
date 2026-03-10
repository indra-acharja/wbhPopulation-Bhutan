# wbhPopulation-Bhutan
White-bellied Heron annual population count data from Bhutan

# White-bellied Heron (*Ardea insignis*)

The White-bellied Heron is a Critically Endangered species restricted to the eastern Himalayas, occurring in Bhutan, northeast India, Myanmar, and parts of China. It is the second-largest heron in the world and among the rarest, with fewer than 250 mature individuals estimated globally. However, fewer than 60 individuals and only four to six breeding pairs are currently known.

This repository contains population data compiled to support long-term monitoring of the species. The dataset is intended to help track population trends, improve understanding of distribution and breeding status, and support conservation research and management.

## Data origin

The data were collected through annual field surveys coordinated by the Royal Society for the Protection of Nature (RSPN) in collaboration with the Department of Forests and Park Services, Local Conservation Support Groups (LCSGs), volunteers, birdwatchers, and local communities.

Surveys are conducted each year at the start of the breeding season, usually from late February to early March, over five consecutive days. This timing coincides with courtship, when birds are more active and more readily detected. Annual counts have been carried out consistently for the past two decades using standardized methods, with additional nest surveys and focused breeding monitoring incorporated since 2015.

## Data file
The dataset is provided as a CSV file named `wbh_population_counts.csv`. Each row represents a single sighting (or as indicated) of a White-bellied Heron. 

## Data Columns
The dataset is organized in a tabular format with the following columns:

- **`Location`**: The location where herons were sighted.
- **`Year`**: The year of the survey (from 2003 to the current year).
- **`Count`**: The number of White-bellied Herons observed (usually one).
- **`Lat`**: Latitude of the sighting location.
- **`Long`**: Longitude of the sighting location.
- **`River`**: The river associated with the sighting location.
- **`Basin`**: The broader river basin excluding areas under protected area (parks and wildlife sanctuaries) associated with the sighting location classified as follows:.

  # *Basin classification*:
  - *Upper Punatsangchu*: Punatsangchu and all tributaries under Wangdue and Punakha districts, including any areas upstream of the Wakleytar Bridge.
  - *Lower Punatsangchu*: Punatsangchu and all tributaries under Tsirang and Dagana districts, including any areas downstream of the Wakleytar Bridge through Bhutan-India border.
  - *Upper Mangdechu*: Mangdechu and all tributaries under Trongsa and Zhemgang districts but only upstream Mangdichu-Chamkhar confluence.
  - *Lower Mangdechu*: Mangdechu and all tributaries under Zhemgang district between Magdechu-Chamkharchu confluence to Mangdechu-Drangmechu confluence.
  - *Chamkharchu*: Chamkharchu and all tributaries upstream of Mangdechu-Chamkhar confluence Chamkhar-Drangmechu confluence.
  - *Upper Drangmechu*: Drangmechu and all tributaries under Trashigang, Trashiyangtse, and Pemagatshel districts but only upstream of Drangmechu-Kurichu confluence.
  - *Lower Drangmechu*: Drangmechu and all tributaries under Pemagatshel and Zhemgang districts between Drangmechu-Kurichu confluence to Drangmechu-Mangdechu confluence.
  - *Kurichu*: Kurichu and all tributaries under Mongar and Lhuentse districts upstream of Kurichu-Drangmechu confluence.
  - *RMNP*: All rivers and tributaris that fall under jurisdiction of Royal Manas National Park.
  - *PWS*: All rivers and tributaries that fall under jurisdiction of Phibsoo Wildlife Sanctuary.