CREATE TABLE IF NOT EXISTS public.data_lake_funnel
(
    date timestamptz not null,
    day integer not null,
    funnel text not null,
    funnel_detail text not null,
    rate double precision not null
);

CREATE INDEX idx_dl_funnel ON public.data_lake_funnel (date, day);
CREATE UNIQUE INDEX udx_dl_funnel ON public.data_lake_funnel (date, day);
