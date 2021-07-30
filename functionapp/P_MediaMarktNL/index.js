const PS5 = require('@laurekamalandua/ps5-availability');

module.exports = async function (context, timer) {
  try {
    context.result = await PS5.Environment.checkAvailability('mediamarktnl');
  } catch (error) {
    context.log(error);
  }
};
