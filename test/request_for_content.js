const RequestForContent = artifacts.require("RequestForContent");


contract("RequestForContent", function (accounts) {
  it("should assert true", async function () {
    await RequestForContent.deployed();
    return assert.isTrue(true);
  });
});
