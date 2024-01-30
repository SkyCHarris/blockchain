
//! Chapter 14: Web3.js

// Solidity contract is complete! Now we need a JS frontend that interacts with the contract
// Ethereum has a JS library called Web3.js

// Later we'll go over in depth how to deploy a contract and set up a Web3.js
// For now let's look at some sample code for how Web3.js interacts wtih our deployed contract

// How we access our contract
var abi = /* abi generated by compiler */
var ZombieFactoryContract = web3.eth.contract(abi)
var contractAddress = /* our contract address on Ethereum after deploying */
var ZombieFactory = ZombieFactoryContract.at(contractAddress)
// 'ZombieFactory' has access to our contract's public functions and events

// event listener to take text input:
$("#ourButton").click(function(e) {
    var name = $("#nameInput").val()
    // Call our contract's 'createRandomZombie' function:
    ZombieFactory.createRandomZombie(name)
})

// Listen for 'NewZombie' event, update the UI
var event = ZombieFactory.NewZombie(function(error, result) {
    if (error) return
    generateZombie(result.zombieId, result.name, result.dna)
})

// take Zombie dna, update image
function generateZombie(id, name, dna) {
    let dnaStr = String(dna)
    // pad DNA with leading zeroes if less than 16 characters
    while (dnaStr.length < 16)
        dnaStr = "0" + dnaStr

    let zombieDetails = {
        // first 2 digits make up the head. 7 possible heads, so % 7
        // to get a number 0-6, then add 1 to make it 1-7.
        // Then we have 7 image files named 'head1.png' through 'head7.png'
        headChoice: dnaStr.substring(0, 2) % 7 + 1,
        // 2nd 2 digits make up the eyes, 11 variations:
        eyeChoice: dnaStr.substring(2, 4) % 11 + 1,
        // 6 variations of shirts:
        shirtChoice: dnaStr.substring(4, 6) % 6 + 1,
        // Last 6 digits for color. Updated using css filter hue-rotate
        skinColorChoice: parseInt(dnaStr.substring(6, 8) / 100 * 360),
        eyeColorChoice: parseInt(dnaStr.substring(8, 10) / 100 * 360),
        clothesColorChoice: parseInt(dnaStr.substring(10, 12) / 100 * 360),
        zombieName: name,
        zombieDescription: "A Level 1 CryptoZombie"
    }
    return zombieDetails
}

// Our JS then takes the values generated in zombieDetails, uses browser-based JS magic, swaps out images and applies CSS Filters