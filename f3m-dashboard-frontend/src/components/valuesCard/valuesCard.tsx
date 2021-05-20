import React, { FunctionComponent, useState, useEffect } from 'react';
//INSIDE COMPONENTS

//OUTSIDE COMPONENTS
import Paper from '@material-ui/core/Paper';
import { makeStyles, Typography, Divider } from '@material-ui/core';
import ArrowUpwardIcon from '@material-ui/icons/ArrowUpward';
import Loader from "react-loader-spinner";
import clsx from 'clsx';

//CSS, STYLES & MEDIA ASSETS

//UTILS

interface ValuesCardProps {
  colorOfValueSection?: string,
  colorTextOfValueSection?: string,
  colorBorderOfValueSection?: string,
  colorTextOfBodyTitleSection?: string,
  colorTextOfBodyTitle2Section?: string,
  percentageColor?: string,
  percentageTextColor?: string,
  value?: any,
  title?: string,
  percentage?: string,
  bodyTitle1?: string,
  bodyContent1?: any,
  bodyTitle2?: string,
  bodyContent2?: any,
  isLoading?: boolean
}

const ValuesCard: FunctionComponent<ValuesCardProps> = ({
  colorOfValueSection = "#e6eff2",
  colorTextOfValueSection = "#444444",
  colorBorderOfValueSection = "#c8dfe8",
  colorTextOfBodyTitleSection = "#9caeb5",
  colorTextOfBodyTitle2Section = "#86959b",
  percentageColor = "rgb(76 175 80 / 10%)",
  percentageTextColor = "#4caf50",
  value = "0",
  title = "No title",
  percentage = "0",
  bodyTitle1 = "No title",
  bodyContent1 = "0",
  bodyTitle2 = "No title",
  bodyContent2 = "0",
  isLoading = true
}) => {

  const useStyles = makeStyles((theme) => ({
    valueSection: {
      background: colorOfValueSection,
      color: colorTextOfValueSection,
      borderTopRightRadius: 6,
      borderTopLeftRadius: 6
    },
    card: {
      borderColor: colorBorderOfValueSection,
      boxShadow: "0px 3px 8px rgba(0,0,0,0.08)",
      color: "#444444",
      borderRadius: 6,
      height: "calc(100% - 30px)",
      marginBottom: 30,
    },
    title: {
      fontWeight: "bold",
      fontFamily: "Open Sans",
      textTransform: "uppercase"
    },
    valuetitle: {
      fontSize: "1.875rem",
      fontWeight: 400
    },
    loaderContainer: {
      textAlign: 'center',
      marginTop: '10px'

    },
    cardloader: {
      position: 'absolute',
      left: '38%',
      top: '38%',
      'z-index': '999'
    },
    percentage: {
      backgroundColor: percentageColor,
      color: percentageTextColor,
      borderRadius: 2,
      display: "inline-block",
      minWidth: 48,
      textAlign: "center",
      verticalAlign: "middle",
      padding: "0 5px"
    },
    percentageCaption: {
      verticalAlign: 1,
      fontWeight: "bold",
    },
    percentageIcon: {
      marginTop: "-4px"
    },
    cardBody: {

    },
    bodyTitle1: {
      fontWeight: "bold",
      fontFamily: "Open Sans",
      textTransform: "uppercase",
      color: colorTextOfBodyTitleSection
    },
    bodyContent1: {
      fontWeight: "normal"
    },
    divider: {
      backgroundColor: colorBorderOfValueSection
    },
    bodyTitle2: {
      fontWeight: 400,
      textTransform: "uppercase",
      color: colorTextOfBodyTitle2Section
    },
    bodyContent2: {
      fontWeight: "normal"
    },
  }));

  const classes = useStyles();

  return (
    <>
      <Paper variant="outlined" className={`${classes.card}`}>
        <div className={`${classes.valueSection} p-4`}>
          <Typography variant="subtitle2" component="h3" className={`${classes.title} mb-3`}>
            {title}
          </Typography>

          <div className={clsx(classes.loaderContainer, classes.cardloader)}>
            <Loader type="TailSpin" color="#5c6bc0" height={50} width={50} visible={isLoading} />
          </div>
          <Typography variant="h4" component="h4" className={`${classes.valuetitle} mb-2`} >
            {value}€
                </Typography>
          <div className={`${classes.percentage}`}>
            <Typography variant="caption" className={classes.percentageCaption}>
              {
                Number(percentage) > 0 &&
                <ArrowUpwardIcon fontSize="small" className={classes.percentageIcon} />
              }
              {percentage}%
                  </Typography>
          </div>
        </div>
        <div className={`${classes.cardBody} p-4`}>
          <Typography variant="caption" component="h5" className={`${classes.bodyTitle1} mb-1`}>
            {bodyTitle1}
          </Typography>
          <Typography variant="h6" component="h5" className={`${classes.bodyContent1}`}>
            {bodyContent1}€
                </Typography>
          <Divider className={`${classes.divider} my-3`} />
          <Typography variant="caption" component="h5" className={`${classes.bodyTitle2} mb-1`}>
            {bodyTitle2}
          </Typography>
          <Typography variant="h6" component="h5" className={`${classes.bodyContent2}`}>
            {bodyContent2}
          </Typography>
        </div>
      </Paper>
    </>
  )
}

export default ValuesCard;
