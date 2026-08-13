# Chicago Taxi Analytics

## 1. Overview

Write 2–3 sentences:
- What you analysed
- BigQuery + dbt
- What the three main questions cover

### Deliverables
- Dashboard: [your link]
- dbt documentation: run `dbt docs generate` and `dbt docs serve`
- Final analytical marts: [mention the three marts]


## 2. Architecture

Explain briefly:
- Raw Chicago Taxi Trips source
- Staging layer
- Intermediate transformation layer
- Mart layer
- `holidays.csv` seed

### Data Lineage

Create your Mermaid diagram here.

### Model Layers

Briefly explain why you separated:
- staging
- intermediate
- marts


## 3. Setup and Reproduction

Write instructions for someone starting from a clean machine/environment:

1. Clone repository
2. Create/activate Python virtual environment
3. Install dependencies
4. Configure Google Cloud authentication
5. Configure `profiles.yml`
6. Verify dbt connection
7. Load seeds
8. Build project
9. Run tests
10. Generate documentation

Include the actual commands you used where appropriate.

Important: don't commit credentials or your service-account secrets.


## 7. Data Quality and Engineering Decisions

### Taxi identity and Q2 interpretation

Decision:
...

Alternative considered:
...

Reason:
...

Trade-off / limitation:
...


### Incomplete trip end timestamps

Decision:
...

Alternative considered:
...

Reason:
...

Trade-off / limitation:
...


### Extreme trip durations

Decision:
...

Alternative considered:
...

Reason:
...

Trade-off / limitation:
...


### Exclusion of 2020–2021 from holiday analysis

Decision:
...

Alternative considered:
...

Reason:
...

Trade-off / limitation:
...


### Holiday baseline contamination

Decision:
...

Alternative considered:
...

Reason:
...

Trade-off / limitation:
...