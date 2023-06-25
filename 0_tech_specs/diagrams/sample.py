from diagrams import Cluster, Diagram

from diagrams.onprem.compute import Server

with Diagram(filename="./outputs/sample"):
    with Cluster("dev"):
        dev_group = [Server("dev")]

    with Cluster("prod"):
        prod_group = [Server("prod")]

    Server("local") >> dev_group >> Server("stage") >> prod_group
