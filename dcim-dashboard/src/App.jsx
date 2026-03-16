import { useEffect, useState } from "react";

function App() {

  const [temperature, setTemperature] = useState([]);

  const fetchTemperature = async () => {
    const res = await fetch("http://localhost:3000/temperature");
    const data = await res.json();
    setTemperature(data);
  };

  useEffect(() => {

    fetchTemperature();

    const interval = setInterval(fetchTemperature, 5000);

    return () => clearInterval(interval);

  }, []);

  return (
    <div style={{padding:"20px"}}>

      <h1>DCIM Monitoring Dashboard</h1>

      <h2>Rack Temperature</h2>

      {temperature.map((t,i)=>(
        <p key={i}>{t.value} °C</p>
      ))}

    </div>
  );
}

export default App;