
from diagrams import Cluster, Diagram

from diagrams.onprem.compute import Server

with Diagram(filename="./outputs/sample"):
    with Cluster("data pipeline"):

        with Cluster("data_ingestion_layer"):
            data_ingestor = Server("ingestor")

        with Cluster("data_processing_layer"):
            data_processor = Server("processor")

        with Cluster("data_analytics_layer"):
            data_analyzer = Server("analyzer")

    data_ingestor >> data_processor >> data_analyzer
