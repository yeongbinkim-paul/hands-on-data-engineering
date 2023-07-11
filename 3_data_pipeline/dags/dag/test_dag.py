from airflow.decorators import dag
from airflow.decorators.task_group import task_group
from airflow.operators.dummy import DummyOperator
from airflow.operators.python_operator import PythonOperator
from datetime import datetime, timedelta

import math

def safe_add(a,b):
    return a+b


# Twitter API credentials
# consumer_key = 'your_consumer_key'
# consumer_secret = 'your_consumer_secret'
# access_token = 'your_access_token'
# access_token_secret = 'your_access_token_secret'

# Define the default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 3, 20),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Instantiate the DAG
@dag(
    dag_id='twitter_crawler',
    default_args=default_args,
    schedule_interval=timedelta(days=1)
)
# Define the function to crawl Twitter data
def crawl_twitter_dag():
    start_task = DummyOperator(task_id="start")
    end_task = DummyOperator(task_id="end")

    @task_group(
        group_id="test_task_group", tooltip="Task group for test"
    )
    def add_task_group():
        start_task_op = DummyOperator(task_id="tg_start")
        end_task_op = DummyOperator(task_id="tg_end")

        add_op = PythonOperator(
            task_id="add_task",
            python_callable=safe_add,
            op_kwargs={
                "a": 1,
                "b": 2
            }
        )
        start_task_op >> add_op >> end_task_op

    add_tg = add_task_group()
    start_task >> add_tg >> end_task
# Set the task dependencies
crawl_twitter = crawl_twitter_dag()
