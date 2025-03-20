
const run = () => setTimeout(() => {
  console.log(`do work: ${Date.now()}`)
  run()
}, Math.random() * 5000)

console.log(`start work`)

run()