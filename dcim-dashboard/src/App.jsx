import { useEffect, useState } from "react";
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  Tooltip,
  CartesianGrid,
  ResponsiveContainer,
  Legend
} from "recharts";

import "./App.css";

function App() {

  const [temperature, setTemperature] = useState([]);
  const [history, setHistory] = useState([]);
  const [lastUpdated, setLastUpdated] = useState("");

  const fetchTemperature = async () => {

    try {

      const res = await fetch("http://localhost:3000/temperature");
      const data = await res.json();

      setTemperature(data);

      setHistory(prev => [
        ...prev.slice(-20),
        {
          time: new Date().toLocaleTimeString(),
          rack1: data[0]?.value,
          rack2: data[1]?.value,
          rack3: data[2]?.value
        }
      ]);

      setLastUpdated(new Date().toLocaleTimeString());

    } catch (err) {
      console.error(err);
    }

  };

  useEffect(() => {

    fetchTemperature();
    const interval = setInterval(fetchTemperature, 5000);
    return () => clearInterval(interval);

  }, []);

  const getStatus = (temp) => {

    if (temp < 30) return "normal";
    if (temp < 35) return "warning";
    return "critical";

  };

  return (

    <div className="container">

      <h1 className="title">DCIM Data Center Monitoring</h1>

      <div className="rack-grid">
        {temperature.map((t, i) => {
          const status = getStatus(t.value);
          return (
            <div key={i} className={`rack-card ${status}`}>
              <h3>Rack {i + 1}</h3>
              <p className="temp">{t.value.toFixed(2)} °C</p>
              <p className="status">{status.toUpperCase()}</p>
            </div>
          );
        })}
      </div>

      <div className="chart-section">
        <h2>Temperature Trend</h2>
        <ResponsiveContainer width="100%" height={300}>
          <LineChart data={history}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="time" />
            <YAxis />
            <Tooltip />
            <Legend />

            <Line
              type="monotone"
              dataKey="rack1"
              stroke="#22c55e"
              strokeWidth={3}
              name="Rack 1"
            />

            <Line
              type="monotone"
              dataKey="rack2"
              stroke="#3b82f6"
              strokeWidth={3}
              name="Rack 2"
            />

            <Line
              type="monotone"
              dataKey="rack3"
              stroke="#f59e0b"
              strokeWidth={3}
              name="Rack 3"
            />
          </LineChart>
        </ResponsiveContainer>

      </div>
      <p className="updated">
        Last Updated: {lastUpdated}
      </p>
    </div>

  );

}

export default App;