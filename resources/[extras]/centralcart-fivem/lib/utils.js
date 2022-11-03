module.exports = {
  Wait: (ms) => new Promise((resolve) => setTimeout(resolve, ms)),

  relativeEvent: (command) => {
    switch (command) {
      case 'ADD_VEHICLE':
        return 'fxserver-events-removeVehicle';

      case 'ADD_GROUP':
        return 'fxserver-events-ungroup';

      case 'ADD_HOME':
        return 'fxserver-events-removeHome';
    }
  },

  SQLdate: (date, days) => {
    return {
      sql: date.toISOString().slice(0, 19).replace('T', ' '),
      days,
    };
  },
};
