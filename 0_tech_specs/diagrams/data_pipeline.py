from diagrams import Cluster, Diagram
from diagrams.custom import Custom
from diagrams.gcp.devtools import Build
from diagrams.onprem.workflow import Airflow


with Diagram(
    filename="./outputs/data_stage",
    node_attr={
        "fixedsize": "false",
        "width": "2.8",
        "height": "2.8",
        "imagescale": "false",
        "fontsize": "25",
    }
):

    legacy_nftbank_pipeline = Build("legacy_nftbank_pipeline")

    with Cluster("Source Data DAGs"):
        with Cluster("offchain exchange source"):
            datasource_offchain_exchange_hourly_dag = Airflow("datasource_offchain_exchange_hourly_dag")
            datalake_offchain_exchange_hourly_dag = Airflow("datalake_offchain_exchange_hourly_dag")


        with Cluster("onchain source"):
            datasource_onchain_default_hourly_dag = Airflow("datasource_onchain_default_hourly_dag")
            datalake_onchain_default_hourly_dag = Airflow("datalake_onchain_default_hourly_dag")
            dataods_default_hourly_dag = Airflow("dataods_default_hourly_dag")

        with Cluster("cfloor target list source"):
            datalake_offchain_opensea_hourly_dag = Airflow("datalake_offchain_opensea_hourly_dag")
            datalake_marketplace_hourly_dag = Airflow("datalake_marketplace_hourly_dag")
            dataods_marketplace_hourly_dag = Airflow("dataods_marketplace_hourly_dag")
            mart_marketplace_hourly_dag = Airflow("mart_marketplace_hourly_dag")

        with Cluster("item premium source"):
            mart_market_price_hourly_dag = Airflow("mart_market_price_hourly_dag")

        with Cluster("offchain metadata source"):
            datasource_offchain_metadata_hourly_dag = Airflow("datasource_offchain_metadata_hourly_dag")
            datasource_offchain_metadata_dependency_hourly_dag = Airflow("datasource_offchain_metadata_dependency_hourly_dag")
            datalake_offchain_metadata_hourly_dag = Airflow("datalake_offchain_metadata_hourly_dag")
            datalake_offchain_metadata_dependency_hourly_dag = Airflow("datalake_offchain_metadata_dependency_hourly_dag")
            dataods_offchain_metadata_dependency_hourly_dag = Airflow("dataods_offchain_metadata_dependency_hourly_dag")

    with Cluster("Data Mart DAG"):
        mart_offchain_exchange_hourly_dag = Airflow("mart_offchain_exchange_hourly_dag")
        mart_marketplace_daily_dag = Airflow("mart_marketplace_daily_dag")
        mlops_estimate_price_daily_dag = Airflow("mlops_estimate_price_daily_dag")
        mart_offchain_metadata_dependency_hourly_dag = Airflow("mart_offchain_metadata_dependency_hourly_dag")
        mart_offchain_metadata_dependency_daily_dag = Airflow("mart_offchain_metadata_dependency_daily_dag")
        mart_onchain_default_hourly_dag = Airflow("mart_onchain_default_hourly_dag")

    with Cluster("Timescale Prod"):
        offchain_erc20_exchange_rates = Custom("offchain_erc20_exchange_rates", "../resources/timescale.png")
        cfloor_target_list = Custom("cfloor_target_list", "../resources/timescale.png")
        offchain_item_premium = Custom("offchain_item_premium", "../resources/timescale.png")
        offchain_collection_metadata = Custom("offchain_collection_metadata", "../resources/timescale.png")
        offchain_item_metadata = Custom("offchain_item_metadata", "../resources/timescale.png")
        marketplace_trade_events = Custom("marketplace_trade_events", "../resources/timescale.png")


    datasource_offchain_exchange_hourly_dag >> datalake_offchain_exchange_hourly_dag >> dataods_default_hourly_dag >> mart_offchain_exchange_hourly_dag >> offchain_erc20_exchange_rates

    datalake_marketplace_hourly_dag >> dataods_marketplace_hourly_dag
    [datalake_offchain_opensea_hourly_dag, dataods_marketplace_hourly_dag] >> mart_marketplace_hourly_dag >> mart_marketplace_daily_dag >> cfloor_target_list

    [mart_market_price_hourly_dag, mart_offchain_exchange_hourly_dag, legacy_nftbank_pipeline] >> mlops_estimate_price_daily_dag >> offchain_item_premium

    datasource_offchain_metadata_hourly_dag >> datalake_offchain_metadata_hourly_dag >> dataods_offchain_metadata_dependency_hourly_dag
    datasource_offchain_metadata_dependency_hourly_dag >> datalake_offchain_metadata_dependency_hourly_dag >> dataods_offchain_metadata_dependency_hourly_dag
    dataods_offchain_metadata_dependency_hourly_dag >> mart_offchain_metadata_dependency_hourly_dag >> mart_offchain_metadata_dependency_daily_dag >> [offchain_collection_metadata, offchain_item_metadata]

    datasource_onchain_default_hourly_dag >> datalake_onchain_default_hourly_dag >> dataods_default_hourly_dag >> mart_onchain_default_hourly_dag >> marketplace_trade_events
