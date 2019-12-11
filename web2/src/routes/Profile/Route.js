import React from "react";
import Profile from "./Profile";
import { PrivateRoute } from "../../components/PrivateRoute";

export const path = "/profile";

const Route = () => (
  <PrivateRoute permissions="user" path={path} component={Profile} />
);

export default Route;
