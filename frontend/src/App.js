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
    loading: false,
  };

  startLoading = () => {
    this.setState({ loading: true });
  };

  setCurrentUser = user => {
    this.setState({ user, loading: false });
    this.props.history.push("/profile");
  };

  render() {
    return (
      <div>
        <Route
          exact
          path="/"
          render={routerProps => (
            <LoginForm
              startLoading={this.startLoading}
              setCurrentUser={this.setCurrentUser}
              {...routerProps}
            />
          )}
        />
        <Route
          exact
          path="/profile"
          render={routerProps => (
            <Profile {...this.state.user} {...routerProps} />
          )}
        />
      </div>
    );
  }
}

export default withRouter(App);
