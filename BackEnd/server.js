require('dotenv').config()
const express = require('express')
const bodyParser = require('body-parser')
const mongoose = require('mongoose')
const session = require('express-session')
const ejs = require('ejs')
const QRCode = require('qrcode')
//Express Settings
const app = express()
app.use(express.static(__dirname + '/public'))
app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())
app.use(
	session({
		secret: process.env.SESSION_SECRET,
		resave: true,
		saveUninitialized: true,
	}),
)
app.set('view engine', 'ejs')

//Mongodb Database Connection
mongoose.set('strictQuery', true)
mongoose
	.connect(process.env.MONGODB_URI, {
		useNewUrlParser: true,
	})
	.then(console.log('Mongodb is connected...'))
//
//
//
//
//
//
//
//
//
//mongoose Models
const StudentSchema = new mongoose.Schema({
	indexNumber: { type: Number, unique: true, required: true, index: true },
	name: String,
	password: String,
})

const Student = new mongoose.model('student', StudentSchema)

const AttendenceSchema = new mongoose.Schema({
      indexnumber:Number,
      subjectcode:String,
      password:String,
      attendeddate:{type:Date,default:Date.now}
})

const Attendence = new mongoose.model('attendence',AttendenceSchema)
//
//
//
//
//
//
//
//
//
//

//Requests Handling

//ISSUING VIEWS
app.get('/enter/users', (req, res) => {
	res.render('EnterUsers.ejs')
})
app.get('/',(req,res)=>{
      res.render('Home.ejs')
})

app.get('/qr/generate',(req,res)=>{
      res.render('QRGenerator.ejs')
})
app.get('/attendence/check', (req, res) => {
      res.render('AttendenceForm.ejs')
      
})
//
//
//
//
//DATA MANAGEMENT
//FROM THE WEB
app.post('/students', async (req, res) => {
	const name = req.body.name
	const index = req.body.index
	const password = req.body.password

	const student = await new Student()
	student.indexNumber = index
	student.name = name
	student.password = password
	try {
		await student.save()
		res.send('<h1>Successfully Saved</h1>')
	} catch (error) {
		if (error.code === 11000) {
			res.send(
				`<h1>${error.keyValue.indexNumber} is already exixts in the system</h1>`,
			)
		}
	}
})
app.get('/students', async (req, res) => {
	const students = await Student.find()
	res.json(students)
})
//
//
//
//
app.post('/qr', (req, res) => {
      const data = req.body
      const qrstring = JSON.stringify(data)
	QRCode.toDataURL(qrstring, function (err, url) {
		res.send(`<img width='500px' height='500px' src='${url}'/>`)
	})
})
app.post('/attendence/check', async (req, res) => {
      const data = req.body
      console.log(data)
      const att = await Attendence.find({subjectcode:data.subjectcode,attendeddate:{"$gte": data.starttime, "$lt": data.endtime}})
      res.render('AttendenceSheet',{att:att})
      
})
//
//
//
//
//
//FROM THE MOBILE APP
app.post('/register', async (req, res) => {
	const index = req.body.index
	const password = req.body.password
	const student = await Student.findOne({
		indexNumber: index,
		password: password,
	})
	if (student) {
		res.json({
			_id: student._id,
			index: student.indexNumber,
			name: student.name,
		})
	} else {
		res.status(500)
		res.json({ message: 'Something went wrong' })
	}
})

app.post('/attendence/mark',async (req,res)=>{
      const data = req.body;
      try {
            const att = await new Attendence(data)
            await att.save()
            res.json({message:'Attendence Marked Successfully'})
      } catch (error) {
            res.json({message:'Failed to Mark Attendence. Try Again '})
      }

})

//START SERVER
app.listen(3000, () => {
	console.log('Start listing at port 3000...')
})
