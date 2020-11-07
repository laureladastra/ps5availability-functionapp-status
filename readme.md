## Introduction

This application checks PS5 console availability at specified time intervals using time triggered Azure Functions.

## Schedule

The Azure Functions are scheduled according to the following pattern

#### **FunctionApp 1**

| Function         | NCRONTAB             | Explanation                                   | Overlap        | Estimated Time |
| ---------------- | -------------------- | --------------------------------------------- | -------------- | -------------- |
| `P_BolNL`        | 0,30 \* \* \* \* \*  | At 00:00:00 and 00:00:30 seconds every minute | P_MediaMarktNL | 2.6 seconds    |
| `P_CoolBlueNL`   | 10,40 \* \* \* \* \* | At 00:00:10 and 00:00:40 seconds every minute | X              | 7 seconds      |
| `P_MediaMarktNL` | 20,50 \* \* \* \* \* | At 00:00:20 and 00:00:50 seconds every minute | X              | 10 seconds     |
