const PS5 = require('@laurekamalandua/ps5-availability');

module.exports = async function (context, timer) {
  try {
    await PS5.Environment.checkAvailability('coolbluenl');
  } catch (error) {
    context.log(error);
  }
};
