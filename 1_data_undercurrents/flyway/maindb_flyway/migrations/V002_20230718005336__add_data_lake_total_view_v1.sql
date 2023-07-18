CREATE TABLE IF NOT EXISTS public.data_lake_total_view
(
    date timestamptz not null,
    day integer not null,
    total_view integer not null,
    one_way_neighbor_view integer not null,
    two_way_neighbor_view integer not null,
    anonymous_view integer not null
);

CREATE INDEX idx_dl_tcv ON public.data_lake_total_view (date, day);
CREATE UNIQUE INDEX udx_dl_tcv ON public.data_lake_total_view (date, day);
