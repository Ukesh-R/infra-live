const express = require("express");
const { MetricServiceClient } = require("@google-cloud/monitoring");

const app = express();
const port = 3000;

const client = new MetricServiceClient();

const projectId = "hybrid-network-architecture";

app.get("/temperature", async (req, res) => {

  const request = {
    name: client.projectPath(projectId),
    filter: 'metric.type="custom.googleapis.com/rack_temperature"',
    interval: {
      startTime: {
        seconds: Date.now() / 1000 - 600,
      },
      endTime: {
        seconds: Date.now() / 1000,
      },
    },
  };

  const [timeSeries] = await client.listTimeSeries(request);

  const data = timeSeries.map(series => ({
    value: series.points[0].value.doubleValue
  }));

  res.json(data);

});

app.listen(port, () => {
  console.log(`DCIM backend running on port ${port}`);
});