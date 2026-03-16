const express = require("express");
const cors = require("cors");
const { MetricServiceClient } = require("@google-cloud/monitoring");

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

const client = new MetricServiceClient();
const projectId = "hybrid-network-architecture";

app.get("/temperature", async (req, res) => {

  try {

    const now = Math.floor(Date.now() / 1000);

    const request = {
      name: client.projectPath(projectId),
      filter: 'metric.type="custom.googleapis.com/rack_temperature"',
      interval: {
        startTime: {
          seconds: now - 600
        },
        endTime: {
          seconds: now
        }
      }
    };

    const [timeSeries] = await client.listTimeSeries(request);

    const data = timeSeries.map(series => ({
      value: series.points[0].value.doubleValue
    }));

    console.log("Temperature sent to frontend:", data);

    res.json(data);

  } catch (error) {

    console.error(error);
    res.status(500).send("Error fetching metrics");

  }

});

app.listen(port, () => {
  console.log(`DCIM backend running on port ${port}`);
});