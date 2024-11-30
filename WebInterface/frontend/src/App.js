import React, { useEffect, useState } from "react";
import axios from "axios";

function App() {
  const [tables, setTables] = useState([]);
  const [selectedTable, setSelectedTable] = useState(null);
  const [tableData, setTableData] = useState([]);

  useEffect(() => {
    axios
      .get("http://localhost:5000/api/tables")
      .then((response) => {
        console.log("Tables fetched:", response.data); // Debug log
        setTables(response.data);
      })
      .catch((error) => {
        console.error("There was an error fetching the tables!", error);
      });
  }, []);

  const handleTableClick = (tableName) => {
    setSelectedTable(tableName);
    axios
      .get(`http://localhost:5000/api/table/${tableName}`)
      .then((response) => {
        console.log(`Data for table ${tableName}:`, response.data); // Debug log
        setTableData(response.data);
      })
      .catch((error) => {
        console.error("There was an error fetching the table data!", error);
      });
  };

  return (
    <div>
      <h1>Database Tables</h1>
      <ul>
        {tables.map((table, index) => (
          <li key={index} onClick={() => handleTableClick(table.TABLE_NAME)}>
            {table.TABLE_NAME}
          </li>
        ))}
      </ul>
      {selectedTable && (
        <div>
          <h2>Data for {selectedTable}</h2>
          <table>
            <thead>
              <tr>
                {tableData.length > 0 &&
                  Object.keys(tableData[0]).map((key, index) => (
                    <th key={index}>{key}</th>
                  ))}
              </tr>
            </thead>
            <tbody>
              {tableData.map((row, index) => (
                <tr key={index}>
                  {Object.values(row).map((value, i) => (
                    <td key={i}>{value}</td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

export default App;
