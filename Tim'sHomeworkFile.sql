#1A
# Display the first and last names of all actors from the table `actor`.
use sakila;
select actor.first_name, actor.last_name from actor

#1B
# Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT CONCAT(actor.first_name, ' ', actor.last_name) as Actor_Name from actor;

#2A
#You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor.first_name, actor.last_name, actor_id from actor where actor.first_name = "Joe";

#2B
#Find all actors whose last name contain the letters `GEN`:
select actor.first_name, actor.last_name from actor where actor.last_name like "%GEN%";

#2C
#Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
select actor.first_name, actor.last_name from actor where actor.last_name like "%LI%";

#2D
#Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country from country where country.country in ("Afghanistan", "Bangladesh", "China");

#3A
#You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
Alter Table actor add column description blob;
select * from actor;

#3B
#Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
Alter  Table actor drop column description;
select * from actor;

#4A
#List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) from actor group by last_name;

#4B
#List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(last_name) from actor group by last_name having count(last_name) > 1;

#4C
#The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
SET SQL_SAFE_UPDATES = 0;
UPDATE actor SET first_name = "Harpo" WHERE first_name = "Groucho";

#4D
#Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor SET first_name = "GROUCHO" WHERE first_name = "Harpo";

#5A
#You cannot locate the schema of the `address` table. Which query would you use to re-create it?
-- CREATE TABLE address (
--   address_id smallint(5) AUTO_INCREMENT NOT NULL,
--   address VARCHAR(50),
--   address2 VARCHAR(50),
--   district VARCHAR(20),
--   dity_id smallint(5),
--   postal_code VARCHAR(10),
--   phone VARCHAR(20),
--   location geometry,
--   last_update timestamp,
--   primary Key(address_id));

#6A
#Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:


#6B
#Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.


#6C
#List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.


#6D
#How many copies of the film `Hunchback Impossible` exist in the inventory system?



#6E
#Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:



#7A
#The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
select title, language_id from film where title in
    (select title from film where title like 'K%' or title like 'Q%')
   and language_id = 1;
   
#7B
# Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT film_id, title 
FROM film 
WHERE title ='Alone Trip';

SELECT first_name, last_name 
FROM actor
WHERE actor_id IN 
(SELECT actor_id 
FROM film_actor 
WHERE film_id=17);

#7C
#You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email FROM customer
JOIN address ON address.address_id = customer.address_id
JOIN city ON city.city_id = address.city_id
JOIN country ON country.country_id = city.country_id
WHERE country = 'Canada';

#7D
#Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
SELECT title FROM film 
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id=category.category_id
WHERE name = "Family"; 

#7E
#Display the most frequently rented movies in descending order.
SELECT title, COUNT(rental_id) AS Total_Rentals FROM film f
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id GROUP BY title
ORDER BY total_rentals DESC;


#7F
#Write a query to display how much business, in dollars, each store brought in.
SELECT store_id, address, sum(amount) as total_dollars FROM address
JOIN store ON store.address_id = address.address_id
JOIN payment ON store.manager_staff_id = payment.staff_id GROUP BY store_id;

#7G
#Write a query to display for each store its store ID, city, and country.
SELECT store_id, address, city, country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city c ON c.city_id = a.city_id
JOIN country cu ON c.country_id = cu.country_id
GROUP BY store_id;

#7H
#List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT name AS film_category, sum(amount) AS total_revenue FROM payment
JOIN rental ON rental.rental_id = payment.rental_id
JOIN inventory ON inventory.inventory_id = rental.inventory_id
JOIN film_category ON film_category.film_id = inventory.film_id
JOIN category ON category.category_id = film_category.category_id
GROUP BY name ORDER BY total_revenue DESC
LIMIT 5;

#8A
#In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_genres AS
SELECT name AS film_category, sum(amount) AS total_revenue
FROM payment
JOIN rental ON rental.rental_id = payment.rental_id
JOIN inventory ON inventory.inventory_id = rental.inventory_id
JOIN film_category ON film_category.film_id = inventory.film_id
JOIN category ON category.category_id = film_category.category_id
GROUP BY name
ORDER BY total_revenue DESC
LIMIT 5;

#8B
#How would you display the view that you created in 8a?
SELECT * FROM top_five_genres;


#8C
#You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top_five_genres; 



