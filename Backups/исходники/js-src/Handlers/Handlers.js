//import db from "../DB/DBConnection.js";
import pg from "pg";
const { Pool } = pg;

let sessionStorage = {
  username: "",
  password: "",
  id: 0
};

/*
базовая строка подключения (как будто мы изначально авторизованы как админ),
но по факту на инерфейсе нет кнопок, реализующих возможности админа...
*/
let db = new Pool({
  user: "administrator",
  password: "qwerty",
  host: "localhost",
  port: 5432,
  database: "kurs",
});

export async function session(req, res) {
  try {
    res.status(200).json(`${sessionStorage.username}`);
    console.log('[LOG] "GET" on /api/penis handled {/myServer/Handlers/Handlers.js:31}');
  } catch (error) {
    console.log(error)
    res.status(500).json({ message: "idi na hui" });
  }
}

export async function createUser(req, res) {
  try {
    /*
    достали из рекуеста.бади поля: пароль и явка
    */
    const { username, password } = req.body;
    /*
    дёрнули функцию СКЛную для добавления усера да-да
    */
    const data = await db.query(
      `SELECT * FROM add_user('${username}', '${password}')`
    );
    res.status(200).json({ message: "user created!" });
    console.log(
      '[LOG] "POST" on /api/create handled {/myServer/Handlers/Handlers.js:31}'
    );
  } catch (error) {
    console.log(error);
    res.status(500).json({ "message": error });
  } // ну и всё, в принципе-то, че бубнить то...
}

export async function getFlights(req, res) {
  try {
    const data = await db.query(`SELECT * FROM flights`);
    res.status(200).json(data.rows);
    console.log(
      '[LOG] "GET" on /api/flights handled {/myServer/Handlers/Handlers.js:43}'
    );
  } catch (error) {
    res.status(200).json({ message: "access denied" });
  }
}

export async function checkIfUserExists(req, res) {
  try {
    /*
    тут будем проверять, хочет ли человек авторизоваться как админ или как
    обычный пользователь
    */
    const { username, password } = req.body;
    // console.log(req.body);
    const data = await db.query(
      `SELECT login FROM users WHERE login = '${username}'`
    );

    if (username === "Admin" && password === "qwerty") {
      /*
      если произошла попытка авторизации как админа, то будем проверять пароль и,
      в случае правильного пароля создавать подключение к базе данных с аккаунта 
      с полными правами
      */
      db.end();
      db = new Pool({
        user: "administrator",
        password: "qwerty",
        host: "localhost",
        port: 5432,
        database: "kurs",
      });

      sessionStorage.username = "Admin";
      sessionStorage.id = -1;

      // const dataAUTH = await db.query(`SELECT user`); // здесь происходит проверка строки подключения
      // console.log(dataAUTH.rows);
      res.status(200).json({ message: "Admin authenticated" });
      /*
      даём ответ, что всё ок
      */
    } else {
      /*
      если же у нас не было попытки авторизоваться как админ, 
      тогда сразу же создаём строку подключения default_user (юзер в постгресах с 
      ограниченными правами) и будем проверять, есть ли такой пользователь вообще
      и правильный ли он ввёл пароль
      */
      db.end();
      db = new Pool({
        user: "default_user",
        password: "12345678",
        host: "localhost",
        port: 5432,
        database: "kurs",
      });

      // const dataAUTH = await db.query(`SELECT user`);
      // console.log(dataAUTH.rows);

      if (data.rowCount === 1) {
        /*
        здесь смотрим, сколько рядов нам вернулось из базы данных (в запросе в строке 36)
        если один, что значит, что есть одно совпадение по усернаме, а это значит, что
        пользователь правильно ввёл логин (существующий)
        */
        const dataPassword = await db.query(
          `SELECT password FROM USERS WHERE login = '${username}'`
        );
        /*
        здесь мы вытаскиваем пароль из бдшки
        */
        if (dataPassword.rows[0].password === password) {
          /*
          сверяем пароль...
          */
          sessionStorage.username = username;
          sessionStorage.password = password;
          const user_id = await db.query(`SELECT user_id FROM users WHERE login = '${username}'`);
          sessionStorage.id = user_id.rows[0].user_id;
          res
            .status(200)
            .json({ message: ["user found", "authentication success"] });
        } else {
          res
            .status(200)
            .json({ message: ["user found", "authentication failed"] });
        }
      } else if (data.rowCount === 0) {
        /*
        здесь у нас не нашлось совпадений по усернаме, а значит пользовател ошибся при вводе логина
        */
        res.status(200).json({ message: "user not found" });
      }
    }

    console.log(sessionStorage);
    console.log(
      '[LOG] "POST" on /api/auth handled {/myServer/Handlers/Handlers.js:122}'
    );
  } catch (error) {
    console.log(error);
    res.status(500).json({
      message:
        "zvonite: +7(985)704-07-57 (Ivan Lavrushko), on gde-to nakosyachil",
    });
  }
}

export async function getAllUsers(req, res) {
  try {
    /*
    ну тут ваще всё просто...
    */
    const data = await db.query(`SELECT * FROM users`);
    res.status(200).json(data);
    console.log(
      '[LOG] "GET" on /api/all handled {/myServer/Handlers/Handlers.js:141}'
    );
  } catch (error) {
    /*
    аксес дениед это если мы из-под обычного усера пытаемся дёрнуть инфу,
    которая ему не предназначена
    */
    res.status(400).json({ message: "access denied" });
    console.log(
      '[LOG] "GET" on /api/all handled {/myServer/Handlers/Handlers.js:150}'
    );
  }
}

/* SELECT * FROM delete_data_from_users(3); */
export async function deleteAccount(req, res) {
  try {
    const delDeps = await db.query(`
      SELECT ticket_id FROM tickets WHERE passanger_id = ${sessionStorage.id}
    `);

    if (delDeps.rows.length != 0) {
      for (let i = 0; i < delDeps.rows.length; i++) {
        const deletion = await db.query(`
        SELECT * FROM delete_data_from_tickets(${delDeps.rows[i].ticket_id})
      `);
      }
    }

    const data = await db.query(
      `SELECT * FROM delete_data_from_users(${sessionStorage.id})`
    );
    res.status(200).json({ message: "account deleted" });
    console.log(
      '[LOG] "GET" on /api/deleteAcc handled {/myServer/Handlers/Handlers.js:168}'
    );
  } catch (error) {
    console.log(error);
    res.status(500).json({
      message:
        "zvonite: +7(985)704-07-57 (Ivan Lavrushko), on gde-to nakosyachil",
    });
  }
}

export async function changeUsername(req, res) {
  try {
    const { username, password } = req.body;
    const data = await db.query(
      `SELECT * FROM UpdatePassword('${sessionStorage.id}', '${username}', '${password}')`
    );
    res.status(200).json({ message: "update success" });
    console.log(
      '[LOG] "POST" on /api/changeUsername handled {/myServer/Handlers/Handlers.js:199}'
    );
  } catch (error) {
    console.log(error);
    res.status(500).json({
      message:
        "zvonite: +7(985)704-07-57 (Ivan Lavrushko), on gde-to nakosyachil",
    });
  }
}

export async function allFlightInfo(req, res) {
  try {
    const data = await db.query(`SELECT * FROM all_flight_info()`);
    res.status(200).json(data.rows);
    console.log('[LOG] "GET" on /api/allFlightInfo handled {/myServer/Handlers/Handlers.js:214}');
  } catch (error) {
    console.log(error);
    res.status(500).json({
      message:
        "zvonite: +7(985)704-07-57 (Ivan Lavrushko), on gde-to nakosyachil",
    });
  }
}

export async function popular(req, res) {
  try {
    const data = await db.query(`
      SELECT airpale_name, seats, reserved_seats FROM airplanes WHERE reserved_seats > (
	      SELECT AVG(reserved_seats) FROM airplanes
      ) AND reserved_seats != seats;
    `);

    res.status(200).json(data.rows);
    console.log('[LOG] "GET" on /api/popular handled {/myServer/Handlers/Handlers.js:233}');
  } catch (error) {
    console.log(error);
    res.status(500).json({
      message:
        "zvonite: +7(985)704-07-57 (Ivan Lavrushko), on gde-to nakosyachil",
    });
  }
}

export async function fast(req, res) {
  try {
    const data = await db.query(`
      SELECT departure_date, arrival_date, departure_city, arrival_city FROM flights WHERE arrival_date - departure_date < (
	      SELECT AVG(arrival_date - departure_date) FROM flights
      );
    `);

    res.status(200).json(data.rows);
    console.log('[LOG] "GET" on /api/fast handled {/myServer/Handlers/Handlers.js:252}');
  } catch (error) {
    console.log(error);
    res.status(500).json({
      message:
        "zvonite: +7(985)704-07-57 (Ivan Lavrushko), on gde-to nakosyachil",
    });
  }
}

export async function info(req, res) {
    try {
    const data = await db.query(`
      SELECT airpale_name FROM airplanes WHERE seats > (
        SELECT AVG(seats) FROM airplanes
      );
    `);

    res.status(200).json(data.rows);
    console.log('[LOG] "GET" on /api/info handled {/myServer/Handlers/Handlers.js:271}');
  } catch (error) {
    console.log(error);
    res.status(500).json({
      message:
        "zvonite: +7(985)704-07-57 (Ivan Lavrushko), on gde-to nakosyachil",
    });
  }
}

export async function departures(req, res) {
  try {
    const data = await db.query(`
      SELECT * FROM (
        SELECT departure_date, arrival_date, departure_city, arrival_city FROM flights
      ) AS flights;
  `);

    res.status(200).json(data.rows);
    console.log('[LOG] "GET" on /api/departures handled {/myServer/Handlers/Handlers.js:290}');
  
  } catch (error) {
    console.log(error);
    res.status(500).json({
    message:
      "zvonite: +7(985)704-07-57 (Ivan Lavrushko), on gde-to nakosyachil",
    });
  }
}

export async function findBuisyness(req, res) {
  try {
    const data = await db.query(`
      SELECT * FROM tickets WHERE price > (
        SELECT AVG(price) FROM tickets
      );
  `);

    res.status(200).json(data.rows);
    console.log('[LOG] "GET" on /api/findBuisyness handled {/myServer/Handlers/Handlers.js:271}');
  
  } catch (error) {
    console.log(error);
    res.status(500).json({
    message:
      "zvonite: +7(985)704-07-57 (Ivan Lavrushko), on gde-to nakosyachil",
    });
  }
}

export async function buyTicket(req, res) {
  try {
    const { flight } = req.body;

    const approval = await db.query(`select count(ticket_id) from tickets where flight = ${flight} and passanger_id = ${sessionStorage.id}`);
    if (approval.rows[0].count > 0) {
      console.log(approval.rows[0].count);
      res.status(400).json({ messasge: "one account is able to buy only one ticket on a single flight!" });
      return
    }

    const data = await db.query(`SELECT * FROM data_insertion_for_tickets_func(500.0, ${flight}, ${sessionStorage.id})`);
    res.status(200).json({message: "ticket was bought"});
    console.log('[LOG] "POST" on /api/buyTicket handled {/myServer/Handlers/Handlers.js:334}');
  
  } catch (error) {
    console.log(error);
    res.status(500).json({
    message:
      "zvonite: +7(985)704-07-57 (Ivan Lavrushko), on gde-to nakosyachil",
    });
  }
}

export async function createAirplane(req, res) {
  try {
    const { seats, reserved_seats, airpale_name, port_id } = req.body;
    const data = await db.query(`SELECT * FROM data_insertion_for_airplanes(${seats}, ${reserved_seats}, '${airpale_name}', '${port_id}')`);
    res.status(200).json({ message: "airplane added" });
    console.log('[LOG] "POST" on /api/createAirplane handled {/myServer/Handlers/Handlers.js:334}');

  } catch (error) {
    console.log(error);
    res.status(500).json({
    message:
      "zvonite: +7(985)704-07-57 (Ivan Lavrushko), on gde-to nakosyachil",
    });
  }
}

export async function changeAirplane(req, res) {
  try {
    const { seats, reserved_seats, airpale_name, port_id } = req.body;
    const data = await db.query(`SELECT * FROM update_data_for_airplanes('${port_id}', ${seats}, ${reserved_seats}, '${airpale_name}')`);
    res.status(200).json({ message: "airplane changed" });
    console.log('[LOG] "POST" on /api/changeAirplane handled {/myServer/Handlers/Handlers.js:334}');

  } catch (error) {
    console.log(error);
    res.status(500).json({
    message:
      "zvonite: +7(985)704-07-57 (Ivan Lavrushko), on gde-to nakosyachil",
    });
  }
}

export async function deleteAirplane(req, res) {
  try {
    const { port_id } = req.body;
    const id_data = await db.query(`SELECT port_id FROM airplanes WHERE port_id = '${port_id}'`);

    if (id_data.rows.length === 0) {
      res.status(200).json({ message: "no such data" });
    }
    const data = await db.query(`SELECT * FROM delete_data_from_airplanes('${port_id}')`);
    res.status(200).json({ message: "airplane deleted" });
    console.log('[LOG] "POST" on /api/deleteAirplane handled {/myServer/Handlers/Handlers.js:334}');

  } catch (error) {
    console.log(error);
    res.status(500).json({
    message:
      "zvonite: +7(985)704-07-57 (Ivan Lavrushko), on gde-to nakosyachil",
    });
  }
}

export async function createFlight(req, res) {
  try {
    const { _departure_date, _arrival_date, _departure_city, _arrival_city, _id } = req.body;
    const data = await db.query(`SELECT * FROM add_flight('${_departure_date}', '${_arrival_date}', '${_departure_city}', '${_arrival_city}', '${_id}')`);
    res.status(200).json({ message: "flight added" });
    console.log('[LOG] "POST" on /api/createFlight handled {/myServer/Handlers/Handlers.js:334}');

  } catch (error) {
    console.log(error);
    res.status(500).json({
    message:
      "zvonite: +7(985)704-07-57 (Ivan Lavrushko), on gde-to nakosyachil",
    });
  }
}

export async function changeFlight(req, res) {
  try {
    const {
      _departure_date_old,
      _arrival_date_old,
      _departure_city_old,
      _arrival_city_old,
      _airplane_id_old,

      _departure_date_new,
      _arrival_date_new,
      _departure_city_new,
      _arrival_city_new,
      _airplane_id_new

    } = req.body;
    
    const id_data = await db.query(`
      select flight_id from flights 
        where departure_date = '${_departure_date_old}' 
          and arrival_date = '${_arrival_date_old}' 
          and departure_city = '${_departure_city_old}' 
          and arrival_city = '${_arrival_city_old}' 
          and airplane_id = ${_airplane_id_old}
    `);

    const data = await db.query(`
      SELECT * FROM update_data_for_flights(
        ${id_data.rows[0].flight_id}, '${_departure_date_new}', '${_arrival_date_new}', '${_departure_city_new}', '${_arrival_city_new}', ${_airplane_id_new}
      )
    `);
    res.status(200).json({ message: "flight changed" });
    console.log('[LOG] "POST" on /api/changeFlight handled {/myServer/Handlers/Handlers.js:334}');

  } catch (error) {
    console.log(error);
    res.status(500).json({
    message:
      "zvonite: +7(985)704-07-57 (Ivan Lavrushko), on gde-to nakosyachil",
    });
  }
}

export async function deleteFlight(req, res) {
  try {
    const {
    
      _flight_id
    
    } = req.body;

    const id_data = await db.query(`
    
      select flight_id from flights 
        where flight_id = '${_flight_id}'
    
    `);

    const tckt_to_delete = await db.query(`
    
      select ticket_id from tickets where flight = '${_flight_id}'
    
    `);

    if (tckt_to_delete.rows.length != 0) {
      for (let i = 0; i < tckt_to_delete.rows.length; i++) {
        const data_tckt_del = await db.query(`select * from delete_data_from_tickets(${tckt_to_delete.rows[i].ticket_id})`);
      }
    }

    if (id_data.rows.length === 0) {
      res.status(400).json({ message: "no such data" });
    }

    const data = await db.query(`SELECT * FROM delete_data_from_flights(${_flight_id})`);
    res.status(200).json({ message: "flight deleted" });
    console.log('[LOG] "POST" on /api/deleteFlight handled {/myServer/Handlers/Handlers.js:334}');

  } catch (error) {
    console.log(error);
    res.status(500).json({
    message:
      "zvonite: +7(985)704-07-57 (Ivan Lavrushko), on gde-to nakosyachil",
    });
  }
}

export async function createTicket(req, res) {
  try {
    const { price, flight, user_id } = req.body;
    const data = await db.query(`CALL data_insertion_for_tickets(${price}, ${flight}, ${user_id})`);
    res.status(200).json({ message: "ticket created" });
    console.log('[LOG] "POST" on /api/createTicket handled {/myServer/Handlers/Handlers.js:334}');
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "error occured" });
  }
}

export async function changeTicket(req, res) {
  try {
    const { price, flight, user_id } = req.body;

    const ticket_id = await db.query(`select ticket_id from tickets where passanger_id = ${user_id} and flight = ${flight}`);
    if (ticket_id.rows.length === 0) {
      res.status(400).json({ message: "no such data" });
      return;
    }

    const data = await db.query(`SELECT * FROM update_data_for_tickets(${ticket_id.rows[0].ticket_id}, ${price}, ${flight}, ${user_id})`);
    res.status(200).json({ message: "ticket changed" });
    console.log('[LOG] "POST" on /api/changeTicket handled {/myServer/Handlers/Handlers.js:334}');
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "error occured" });
  }
}

export async function deleteTicket(req, res) {
  try {
    const { flight } = req.body;

    const ticket_id = await db.query(`select ticket_id from tickets where passanger_id = ${sessionStorage.id} and flight = ${flight}`);
    if (ticket_id.rows.length === 0) {
      res.status(400).json({ message: "no such data" });
      return;
    }

    const data = await db.query(`SELECT * FROM delete_data_from_tickets(${ticket_id.rows[0].ticket_id})`);
    res.status(200).json({ message: "ticket deleted" });
    console.log('[LOG] "POST" on /api/deleteTicket handled {/myServer/Handlers/Handlers.js:334}');
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "error occured" });
  }
}

export async function burjui(req, res) {
  try {
    const burj = await db.query(`
      SELECT COUNT(user_id) AS buisiness_class FROM users JOIN tickets ON tickets.passanger_id = users.user_id
        GROUP BY price
      HAVING price >= (SELECT AVG(price) FROM tickets);
    `);

    res.status(200).json(burj.rows);
    console.log('[LOG] "GET" on /api/burjui handled {/myServer/Handlers/Handlers.js:334}');
  
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "error occured" });
  }
}

export async function statistics(req, res) {
  try {
    const stats = await db.query(`
      SELECT airpale_name,
        (SELECT COUNT(airplane_id) FROM flights WHERE flights.airplane_id = airplanes.airplane_id)
      FROM airplanes;
    `);

    res.status(200).json(stats.rows);
    console.log('[LOG] "GET" on /api/statistics handled {/myServer/Handlers/Handlers.js:334}');
    
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "error occured" });
  }
}

export async function concurrent(req, res) {
  try {
    const conc = await db.query(`
    SELECT price, flight, passanger_id
	    FROM tickets tckt
	      WHERE flight = ANY(
		      SELECT flight FROM tickets tckt1 WHERE tckt != tckt1
	      );
    `);

    res.status(200).json(conc.rows);
    console.log('[LOG] "GET" on /api/concurrent handled {/myServer/Handlers/Handlers.js:334}');

  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "error occured" });
  }
}

export async function inCompare(req, res) {
  try {
    const { flight } = req.body;

    const inComp = await db.query(`
      SELECT *
	      FROM tickets
        WHERE price > ALL(
		      SELECT price FROM tickets WHERE flight = ${flight}
	    );
    `);

    res.status(200).json(inComp.rows);
    console.log('[LOG] "GET" on /api/inCompare handled {/myServer/Handlers/Handlers.js:334}');
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "error occured" });
  }
}

export async function ticketsOfUser(req, res) {
  try {
    const data = await db.query(`
      SELECT price, code, departure_city, arrival_city, flight_id FROM ticket_for_user WHERE user_id = ${sessionStorage.id};
    `);
    res.status(200).json(data.rows);
    console.log('[LOG] "GET" on /api/ticketsOfUser handled {/myServer/Handlers/Handlers.js:334}');
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "error occured" });
  }
}

export async function clients(req, res) {
  try {
    const data = await db.query(
      `
        SELECT (SELECT login FROM users U WHERE U.user_id = TC.passanger_id), price FROM tickets TC
      `
    );

    res.status(200).json(data.rows);
    console.log('[LOG] "GET" on /api/clients handled {/myServer/Handlers/Handlers.js:334}');
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "error occured" });
  }
}

export async function flightsSettingsTable(req, res) {
  try {
    const data = await db.query(`
        SELECT * FROM flights_for_admin()
      `
    );

    res.status(200).json(data.rows);
    console.log('[LOG] "GET" on /api/clients handled {/myServer/Handlers/Handlers.js:334}');
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "error occured" });
  }
}

export async function ticketsTableForAdmin(req, res) {
  try {
    const data = await db.query(`SELECT * FROM ticket_for_user`);
    res.status(200).json(data.rows);
    console.log('[LOG] "GET" on /api/ticketsTableForAdmin handled {/myServer/Handlers/Handlers.js:334}');
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "error occured" });
  }
}

export async function updateView(req, res) {
  try {
    const { NewPrice, ticket_id} = req.body;

    const data = await db.query(`UPDATE ticket_for_user SET price = ${NewPrice} WHERE ticket_id = ${ticket_id}`);
    res.status(200).json({ message: "view updated" });
    console.log('[LOG] "POST" on /api/updateView handled {/myServer/Handlers/Handlers.js:334}');
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "error occured" });
  }
}