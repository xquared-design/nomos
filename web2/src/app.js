import React from 'react';
import { makeStyles }  from '@material-ui/core';
import CssBaseline from '@material-ui/core/CssBaseline';

import { BrowserRouter as Router, Switch } from 'react-router-dom';
import { IdentityProvider } from './components/Identity';

import { AppBar } from './components/AppBar';
import Routes from './components/Routes';

const useStyles = makeStyles(() => ({
  root: {
    display: 'flex',
  }
}));

export const App = () => {
  const classes = useStyles();

  return (
    <div className={classes.root}>
      <CssBaseline />
      <IdentityProvider>
        <Router>
          <AppBar>
            <Switch>
              <Routes />
            </Switch>
          </AppBar>
        </Router>
      </IdentityProvider>
    </div>
  );
};

export default App;
