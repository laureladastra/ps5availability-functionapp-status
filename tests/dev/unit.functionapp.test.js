process.env.NODE_ENV = 'test';

const { assert } = require('chai');
const { describe, it } = require('mocha');
const {
  runStubFunctionFromBindings,
  createTimerTrigger
} = require('stub-azure-function-context');

const timerFunctionBol = require('../../P_BolNL/index.js');
const timerFunctionCoolBlue = require('../../P_CoolBlueNL/index.js');
const timerFunctionMediamarkt = require('../../P_MediamarktNL/index.js');

const timerBinding = {
  type: 'timerTrigger',
  name: 'timer',
  direction: 'in',
  data: createTimerTrigger()
};

describe('PS5 Availability Azure Functions', async function () {
  // Disable timeout globally for the test suite
  this.timeout(0);
  // Disable slow benchmak for test the test suite
  this.slow(10000);
  describe('P_BolNL', function () {
    describe('checkAvailability()', function () {
      it('function should return true or false', async function () {
        const context = await runStubFunctionFromBindings(timerFunctionBol, [
          timerBinding
        ]);
        assert.oneOf(context.result, [true, false, null]);
      });
    });
  });
  describe('P_CoolBlueNL', function () {
    describe('checkAvailability()', function () {
      it('function should return true or false', async function () {
        const context = await runStubFunctionFromBindings(
          timerFunctionCoolBlue,
          [timerBinding]
        );
        assert.oneOf(context.result, [true, false, null]);
      });
    });
  });
  describe('P_MediaMarktNL', function () {
    describe('checkAvailability()', function () {
      it('function should return true or false', async function () {
        const context = await runStubFunctionFromBindings(
          timerFunctionMediamarkt,
          [timerBinding]
        );
        assert.oneOf(context.result, [true, false, null]);
      });
    });
  });
});
