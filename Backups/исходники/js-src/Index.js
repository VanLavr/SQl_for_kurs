import dotenv from "dotenv";
import express from "express";
import cors from "cors";
import {
  createUser,
  checkIfUserExists,
  getAllUsers,
  deleteAccount,
  getFlights,
  changeUsername,
  allFlightInfo,
  popular,
  fast,
  info,
  departures,
  findBuisyness,
  buyTicket,
  createAirplane,
  changeAirplane,
  deleteAirplane,
  createFlight,
  changeFlight,
  deleteFlight,
  createTicket,
  changeTicket,
  deleteTicket,
  burjui,
  statistics,
  concurrent,
  inCompare,
  session,
  ticketsOfUser,
  clients,
  flightsSettingsTable,
  ticketsTableForAdmin,
  updateView,
} from "./Handlers/Handlers.js";

dotenv.config();

const PORT = process.env.PORT || 8080;

const app = express();
const router = express();

app.use(cors());
app.use(express.json());

app.use("/api", router);
router.get("/session", session);
router.get("/flights", getFlights);
router.post("/create", createUser);
router.post("/auth", checkIfUserExists);
router.get("/all", getAllUsers);
router.get("/deleteAcc", deleteAccount);
router.post("/changeUsername", changeUsername);
router.get("/allFlightInfo", allFlightInfo);
router.get("/popular", popular);
router.get("/fast", fast);
router.get("/info", info);
router.get("/departures", departures);
router.get("/findBuisyness", findBuisyness);
router.post("/buyTicket", buyTicket);
router.post("/createAirplane", createAirplane);
router.post("/changeAirplane", changeAirplane);
router.post("/deleteAirplane", deleteAirplane);
router.post("/createFlight", createFlight);
router.post("/changeFlight", changeFlight);
router.post("/deleteFlight", deleteFlight);
router.post("/createTicket", createTicket);
router.post("/changeTicket", changeTicket);
router.post("/deleteTicket", deleteTicket);
router.get("/burjui", burjui);
router.get("/statistics", statistics);
router.get("/concurrent", concurrent);
router.post("/inCompare", inCompare);
router.get("/ticketsOfUser", ticketsOfUser);
router.get("/clients", clients);
router.get("/flightsSettingsTable", flightsSettingsTable);
router.get("/ticketsTableForAdmin", ticketsTableForAdmin);
router.post("/updateView", updateView);

const start = () => {
  try {
    app.listen(PORT, () => console.log(`Server started on port ${PORT}`));
  } catch (error) {
    console.log(error);
  }
};

start();
