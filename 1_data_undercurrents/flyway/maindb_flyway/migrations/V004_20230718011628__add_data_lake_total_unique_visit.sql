CREATE TABLE IF NOT EXISTS public.data_lake_total_unique_visit
(
    date timestamptz not null,
    day integer not null,
    u_total_visit integer not null,
    u_one_way_neighbor_visit integer not null,
    u_two_way_neighbor_visit integer not null,
    u_anonymous_visit integer not null
);

CREATE INDEX idx_dl_tcuv ON public.data_lake_total_unique_visit (date, day);
CREATE UNIQUE INDEX udx_dl_tcuv ON public.data_lake_total_unique_visit (date, day);
