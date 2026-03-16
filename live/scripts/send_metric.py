import random
import time
from google.cloud import monitoring_v3

project_id = "hybrid-network-architecture"

client = monitoring_v3.MetricServiceClient()
project_name = f"projects/{project_id}"

racks = ["rack_1", "rack_2", "rack_3"]

while True:

    for rack in racks:

        series = monitoring_v3.TimeSeries()

        series.metric.type = "custom.googleapis.com/rack_temperature"

        # LABEL FOR EACH RACK
        series.metric.labels["rack_id"] = rack

        series.resource.type = "global"
        series.resource.labels["project_id"] = project_id

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

        print(f"{rack} temperature sent")

    time.sleep(5)