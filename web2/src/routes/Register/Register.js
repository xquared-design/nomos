import React, { useState } from "react";

import { makeStyles } from "@material-ui/core/styles";
import Container from "@material-ui/core/Container";
import Stepper from "@material-ui/core/Stepper";
import Step from "@material-ui/core/Step";
import StepLabel from "@material-ui/core/StepLabel";

import StageOne from "./StageOne";
import StageTwo from "./StageTwo";
import StageThree from "./StageThree";
import Finished from "./Finished";
import { Paper, Typography } from "@material-ui/core";

const useStyles = makeStyles(theme => ({
  container: {},
  paper: {
    padding: theme.spacing(2)
  }
}));

const Register = () => {
  const classes = useStyles();

  const [info, setInfo] = useState({
    email: "",
    firstname: "",
    lastname: "",

  });

  const [step, setStep] = useState(0);

  const completeStage = index => () => setStep(index + 1);

  return (
    <Container className={classes.container}>
      <Paper className={classes.paper}>
        <Typography variant="h6">New Member Registration</Typography>
        <Stepper activeStep={step}>
          <Step>
            <StepLabel>Member Details</StepLabel>
          </Step>
          <Step>
            <StepLabel>Create Account</StepLabel>
          </Step>
          <Step>
            <StepLabel>Payment</StepLabel>
          </Step>
        </Stepper>

        {step === 0 && <StageOne onComplete={completeStage(0)} />}
        {step === 1 && <StageTwo onComplete={completeStage(1)} />}
        {step === 2 && <StageThree onComplete={completeStage(2)} />}
        {step > 2 && <Finished />}
      </Paper>
    </Container>
  );
};

export default Register;
