const PS5 = require('@laurekamalandua/ps5-availability');

module.exports = async function (context, timer) {
  try {
    context.result = await PS5.Environment.checkAvailability('bolnl');
  } catch (error) {
    context.log(error);
  }
};
