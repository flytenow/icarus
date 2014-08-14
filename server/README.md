# Server

> Server for icarus.

## Build & Run

Make sure you are in the `/server` directory. Then, run `npm install` to download the latest node dependencies. To run the server, just run `node server.js`. Make sure you have set up the database and imported the latest data. Check out the [data README file](https://github.com/flytenow/icarus/blob/master/data/README.md) to see how to do this. 

## API Documentation

### GET `/info`

#### Returns

| Node | Type | Description |
| --- | --- | --- |
| `distinct` | `object<array<string>>` | An object containing certain columns as keys and an array of strings representing the distinct values of that column as the value. |
| `range` | `object<tuple<ceil, floor>>` | An object containing certain columns as keys and an object with keys `ceil` and `floor` representing the max and min value of that column. |
| `maxRows` | `int` | The total number of events in the database. |

### GET `/query`

#### Parameters

| Node | Type | Required | Description |
| --- | --- | --- | --- |
| `dateLow` | `int` | true | The low end of the date range. |
| `dateHigh` | `int` | true |The high end of the date range. |
| `source` | `string` | false | Which government database to retrieve events from. |

#### Returns

| Node | Type | Description |
| --- | --- | --- |
| `activeRows` | `int` | The number of events that are being used to calculate totals for the graph. |
| `maxRows` | `int` | The total number of events in the database. |
| `years` | `array<year>` | An array of `year` objects that contains totals for each year. |

##### `year` Object

| Node | Type | Description |
| --- | --- | --- |
| `year` | `string` | A string representation of the year. |
| `events` | `int` | The total number of applicable events that occurred in the given year. |
| `fatalities` | `int` | The total number of fatalities from applicable events that occurred in the given year. |
| `injuries` | `int` | The total number of injuries from applicable events that occurred in the given year. |
