import React, { Component } from "react";
import { Typography } from "@material-ui/core";
import { makeStyles } from '@material-ui/core/styles';
import clsx from 'clsx';

const useStyles = makeStyles((theme) => ({
  root: {
    color: "#999999",
    padding: "5px 13px",
    display: "flex",
    justifyContent: "space-between",
    flexWrap: "wrap"
  },
  footerText: {
  },
  copyRightText:{
  },
  primaryText:{
    color: "#0098d2"
  }
}));

export default function Footer() {
  const classes = useStyles();
    return (
      <footer className={classes.root}>
        <Typography variant="caption" className={classes.footerText}>
          Licenciado a : F3M INFORMATION SYSTEMS, S.A. | Contribuinte: 501854371
        </Typography>
        <Typography variant="caption" className={classes.copyRightText}>
          Copyright © 2019 F3M - <span className={classes.primaryText}>Information Systems, S.A.</span> | V 1.4.0
        </Typography>
      </footer>
    );
}
