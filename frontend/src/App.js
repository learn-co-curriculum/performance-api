import React from "react";
import LoginForm from "./components/LoginForm";
import Profile from "./components/Profile";
import { withRouter, Route } from "react-router-dom";

class App extends React.Component {
  state = {
    user: {
      id: null,
      username: null,
      movies: [],
    },
  };

  setCurrentUser = user => {
    this.setState({ user }, () => console.log(this.state));
    // this.props.history.push("/profile");
  };

  render() {
    return (
      <div>
        <LoginForm setCurrentUser={this.setCurrentUser} />
      </div>
    );
  }
}

export default withRouter(App);
