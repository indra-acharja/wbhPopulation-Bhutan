# wbhPopulation-Bhutan
White-bellied Heron annual population count data from Bhutan

# White-bellied Heron (*Ardea insignis*)

The White-bellied Heron is a Critically Endangered species restricted to the eastern Himalayas, occurring in Bhutan, northeast India, Myanmar, and parts of China. It is the second-largest heron in the world and among the rarest, with fewer than 250 mature individuals estimated globally. However, fewer than 60 individuals and only four to six breeding pairs are currently known.

This repository contains population data compiled to support long-term monitoring of the species. The dataset is intended to help track population trends, improve understanding of distribution and breeding status, and support conservation research and management.

## Data origin

The data were collected through annual field surveys coordinated by the Royal Society for the Protection of Nature (RSPN) in collaboration with the Department of Forests and Park Services, Local Conservation Support Groups (LCSGs), volunteers, birdwatchers, and local communities.

Surveys are conducted each year at the start of the breeding season, usually from late February to early March, over five consecutive days. This timing coincides with courtship, when birds are more active and more readily detected. Annual counts have been carried out consistently for the past two decades using standardized methods, with additional nest surveys and focused breeding monitoring incorporated since 2015.

## Project Structure
Based on the repository organization, the project is structured as follows:

* **`2026_trend_analysis.R`**: The core R script used for data cleaning, baseline comparison, and visualization.
* **`population_count.xlsx`**: The primary source file containing historical and current survey records.
* **`tables_plots/`**: The output directory where the script exports all generated CSV tables and high-resolution plots.
* **`README.md`**: Project documentation and data dictionary.
* **`wbhPopulation-Bhutan.Rproj`**: RStudio project file for standardized workspace management.

## Data Dictionary
The dataset follows this tabular format:

- **`Location`**: The specific site where herons were sighted.
- **`Year`**: The year of the survey (2003–2026).
- **`Count`**: The number of White-bellied Herons observed.
- **`Lat` / `Long`**: Latitude and longitude of the sighting location.
- **`River`**: The river associated with the sighting.
- **`Basin`**: The broader river basin excluding protected areas (parks and wildlife sanctuaries).

### Basin Classification Descriptions
Locations are classified into the following basins:

- **Upper Punatsangchu**: Punatsangchu and tributaries under Wangdue and Punakha; upstream of Wakleytar Bridge.
- **Lower Punatsangchu**: Punatsangchu and tributaries under Tsirang and Dagana; downstream of Wakleytar Bridge to the border.
- **Upper Mangdechu**: Mangdechu and tributaries under Trongsa and Zhemgang; upstream of Mangdechu-Chamkhar confluence.
- **Lower Mangdechu**: Mangdechu and tributaries between Magdechu-Chamkharchu and Mangdechu-Drangmechu confluences.
- **Chamkharchu**: Chamkharchu and tributaries upstream of Mangdechu-Chamkhar and Chamkhar-Drangmechu confluences.
- **Upper Drangmechu**: Drangmechu and tributaries under Trashigang, Trashiyangtse, and Pemagatshel; upstream of Drangmechu-Kurichu confluence.
- **Lower Drangmechu**: Drangmechu and tributaries between Drangmechu-Kurichu and Drangmechu-Mangdechu confluences.
- **Kurichu**: Kurichu and tributaries under Mongar and Lhuentse upstream of Kurichu-Drangmechu confluence.
- **RMNP**: All rivers and tributaries under the jurisdiction of Royal Manas National Park.
- **PWS**: All rivers and tributaries under the jurisdiction of Phibsoo Wildlife Sanctuary.

## Analysis Workflow
The `2026_trend_analysis.R` script automates the following workflow:
1. **Data Cleaning**: Squishing strings, handling NA values, and filtering for counts > 0.
2. **Annual Summaries**: Aggregating total counts, occupied locations, rivers, and basins by year.
3. **Comparative Analysis**: Calculating growth/decline in 2026 relative to 2025 and a 5-year baseline (2020–2025).
4. **Visualization**: Generating individual trend lines, stacked bar charts for spatial distribution, and comparison plots.

## Generated Outputs
The following files are exported to the `tables_plots/` directory:

| Output Category | Description |
| :--- | :--- |
| **Tables (CSV)** | Summary by year, 2026 comparisons, annual rankings, and location-specific data. |
| **Trend Plots** | Figures 1–4: Population, location, river, and basin trends over time. |
| **Spatial Charts** | Figures 5–6: Annual counts stacked by basin and river. |
| **Comparison Charts** | Figures 7–12: 2026 performance vs. 2025 and the baseline mean. |
| **Paginated Facets** | Figures 13–14: Detailed count trends for every individual basin and river. |

## How to Run
1. Open the **`wbhPopulation-Bhutan.Rproj`** file in RStudio.
2. Ensure required libraries (`dplyr`, `ggplot2`, `ggforce`, `patchwork`, etc.) are installed.
3. Run the **`2026_trend_analysis.R`** script.
4. All processed tables and 1200 DPI visualizations will be automatically saved in the **`tables_plots/`** folder.