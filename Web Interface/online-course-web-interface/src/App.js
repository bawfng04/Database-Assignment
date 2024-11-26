import React, { useState, useEffect } from "react";
import "./App.css";

function App() {
  const [courses, setCourses] = useState([]);
  const [chapters, setChapters] = useState([]);
  const [tests, setTests] = useState([]);
  const [score, setScore] = useState(null);

  useEffect(() => {
    fetch("http://localhost:5000/courses")
      .then((response) => response.json())
      .then((data) => setCourses(data));

    fetch("http://localhost:5000/chapters")
      .then((response) => response.json())
      .then((data) => setChapters(data));

    fetch("http://localhost:5000/tests")
      .then((response) => response.json())
      .then((data) => setTests(data));
  }, []);

  const calculateScore = (courseId, chapterName, testOrder) => {
    fetch(
      `http://localhost:5000/calculateTestScore?courseId=${courseId}&chapterName=${chapterName}&testOrder=${testOrder}`
    )
      .then((response) => response.json())
      .then((data) => setScore(data.Score));
  };

  return (
    <div className="App">
      <h1>Courses</h1>
      <ul>
        {courses.map((course) => (
          <li key={course.Course_ID}>{course.Course_Name}</li>
        ))}
      </ul>

      <h1>Chapters</h1>
      <ul>
        {chapters.map((chapter) => (
          <li key={chapter.Chapter_Name}>{chapter.Chapter_Name}</li>
        ))}
      </ul>

      <h1>Tests</h1>
      <ul>
        {tests.map((test) => (
          <li key={test.Test_Order}>{test.Test_Content}</li>
        ))}
      </ul>

      <button onClick={() => calculateScore(1, "Giới thiệu Python", 1)}>
        Calculate Test Score
      </button>
      {score !== null && <p>Test Score: {score}</p>}
    </div>
  );
}

export default App;
