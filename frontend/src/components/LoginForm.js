import React from "react";
import { Button, Form } from "semantic-ui-react";
import Adapter from "../services/Adapter";

class LoginForm extends React.Component {
  state = {
    loading: false,
    username: "",
  };

  handleChange = event => {
    this.setState({ [event.target.name]: event.target.value });
  };

  handleSubmit = event => {
    this.props.startLoading();
    this.setState({ username: "" });
    //😍 the semantic ui react form component prevents default for me 😍
    Adapter.findUser(this.state.username).then(user => {
      this.props.setCurrentUser(user);
    });
  };

  render() {
    return (
      <Form loading={this.props.loading} onSubmit={this.handleSubmit}>
        <Form.Input
          onChange={this.handleChange}
          label="Username"
          name="username"
          value={this.state.username}
        />
        <Button type="submit">Submit</Button>
      </Form>
    );
  }
}

export default LoginForm;
