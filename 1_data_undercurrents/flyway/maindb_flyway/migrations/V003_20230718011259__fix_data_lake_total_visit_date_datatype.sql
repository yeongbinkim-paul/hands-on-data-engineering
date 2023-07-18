DROP INDEX idx_dl_tv;
DROP INDEX udx_dl_tv;

ALTER TABLE public.data_lake_total_visit ALTER COLUMN day TYPE integer USING day::integer;

CREATE INDEX idx_dl_tv ON public.data_lake_total_visit (date, day);
CREATE UNIQUE INDEX udx_dl_tv ON public.data_lake_total_visit (date, day);
