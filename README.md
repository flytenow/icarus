# icarus

> An interactive way to view aviation accident data in the United States.

## Early Preview
![Screenshot](https://dl.dropboxusercontent.com/u/47241567/icarus-preview.png)

## Client
The client is written using AngularJS as a framework. A control panel is provided that allows the user to specify certain constraints on the data they want to view. The parameters are sent to then sent to the server and the graph is updated with the totals pertaining to the user's query. There is also a data utilization bar that shows how much of the event data could be used to calculate the totals.

[See more in the client README.md](https://github.com/flytenow/icarus/blob/master/client/README.md)

## Data
Data is pulled from government databases and compiled into one database. The script attempts to reconcile as much data as possible, but due to the incomplete nature of the government databases many values are null. In the future, data will be pulled from even more databases such as the Air Registry and latitude/longitude APIs to get more complete data.

[See more in the data README.md](https://github.com/flytenow/icarus/blob/master/data/README.md)


## Server
The server is written with the Express framework for NodeJS. Due to the large volumn of data in the events database, all searching and filtering is done server-side. Therefore, the client will provide all the user input and send it to the server where it will be converted into a MySQL query. The rows that are returned by this query are then tallied and grouped by year. Eventually, the results may get more granular and be grouped by month. The server also handles serving up the client and all static files.

[See more in the server README.md](https://github.com/flytenow/icarus/blob/master/server/README.md)

## License
```
The MIT License (MIT)

Copyright (c) 2014 Flytenow

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

