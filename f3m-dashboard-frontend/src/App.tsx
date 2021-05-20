import React, { useEffect } from 'react';
import logo from './logo.svg';
import DashboardPage from './container/dashboard/dashboard'
import './App.css';
import Header from './components/header/header';
import Footer from './components/footer/footer';


function App() {

  return (
    <div className="App">
      {/* <Header /> */}
      <div className="content-wrapper">
        <DashboardPage />
      </div>
      {/* <Footer /> */}
    </div>
  );


}

export default App;
