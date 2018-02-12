import React from "react";
import { Redirect } from "react-router-dom";
import { Card } from "semantic-ui-react";

const Profile = ({ movies }) => {
  const movieCards = movies.map((movie, idx) => (
    <Card.Content key={idx}>
      <Card.Header>Title: {movie.title}</Card.Header>
    </Card.Content>
  ));
  return movies && movies.length ? (
    <Card>{movieCards}</Card>
  ) : (
    <Redirect to="/" />
  );
};

export default Profile;
