import React from 'react';
import { makeStyles } from '@material-ui/core/styles';
import IconButton from '@material-ui/core/IconButton';
import CloseIcon from '@material-ui/icons/Close';
import BarChartIcon from '@material-ui/icons/BarChart';

const useStyles = makeStyles((theme) => ({
  root: {
    flexGrow: 1,
    backgroundColor: "#EEF2F3",
    borderBottom: "1px solid #dddddd",
    paddingTop: 10
  },
  items: {
    fontSize: 12,
    fontFamily: "Open Sans",
    backgroundColor: "#FFF",
    color: "#495057",
    display: "inline-flex",
    alignItems: "center",
    padding: "8px 13px",
    borderTopRightRadius: 10,
    borderRight: "1px solid #dddddd",
    borderTop: "1px solid #dddddd",
    marginBottom: -1
  },
  closeButton: {
    padding: 0
  }
}));

export default function Breadcrumbs() {
  const classes = useStyles();

  return (
    <div className={`${classes.root} breadcrumbs`}>
      <div className={classes.items}>
        <BarChartIcon fontSize="small" className="mr-1" /> Dashboard 
        <IconButton size="small" color="inherit" edge="start" className={`${classes.closeButton} ml-1`} aria-label="menu">
          <CloseIcon fontSize="small" />
        </IconButton> 
      </div>
    </div>
  );
}
