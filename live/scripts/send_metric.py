import random
import time
from google.cloud import monitoring_v3

project_id = "hybrid-network-architecture"

client = monitoring_v3.MetricServiceClient()
project_name = f"projects/{project_id}"

while True:
    series = monitoring_v3.TimeSeries()

    # Metric type
    series.metric.type = "custom.googleapis.com/rack_temperature"

    # Resource type
    series.resource.type = "global"

    # REQUIRED LABEL
    series.resource.labels["project_id"] = project_id

    # Create point
    point = monitoring_v3.Point()

    point.value.double_value = random.uniform(28, 35)

    now = time.time()

    point.interval = monitoring_v3.TimeInterval(
        end_time={"seconds": int(now)}
    )

    series.points.append(point)

    client.create_time_series(
        name=project_name,
        time_series=[series],
    )

    print("Temperature sent")

    time.sleep(5)