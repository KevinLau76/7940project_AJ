--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

-- Started on 2024-03-27 15:12:09 HKT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 3635 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 16407)
-- Name: chat_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_history (
    id bigint NOT NULL,
    context text NOT NULL,
    last_update timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_id bigint
);


ALTER TABLE public.chat_history OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16406)
-- Name: chat_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chat_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chat_history_id_seq OWNER TO postgres;

--
-- TOC entry 3636 (class 0 OID 0)
-- Dependencies: 215
-- Name: chat_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chat_history_id_seq OWNED BY public.chat_history.id;


--
-- TOC entry 224 (class 1259 OID 24639)
-- Name: recipe_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recipe_type (
    id bigint NOT NULL,
    type character varying NOT NULL
);


ALTER TABLE public.recipe_type OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24638)
-- Name: recipe_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recipe_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipe_type_id_seq OWNER TO postgres;

--
-- TOC entry 3637 (class 0 OID 0)
-- Dependencies: 223
-- Name: recipe_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recipe_type_id_seq OWNED BY public.recipe_type.id;


--
-- TOC entry 218 (class 1259 OID 24577)
-- Name: system_recipe; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_recipe (
    id bigint NOT NULL,
    recipe_name character varying NOT NULL,
    type integer NOT NULL,
    style character varying NOT NULL
);


ALTER TABLE public.system_recipe OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24576)
-- Name: system_recipe_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.system_recipe_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.system_recipe_id_seq OWNER TO postgres;

--
-- TOC entry 3638 (class 0 OID 0)
-- Dependencies: 217
-- Name: system_recipe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.system_recipe_id_seq OWNED BY public.system_recipe.id;


--
-- TOC entry 220 (class 1259 OID 24584)
-- Name: user_recipe; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_recipe (
    id bigint NOT NULL,
    recipe_name character varying NOT NULL,
    directions text,
    rating real NOT NULL,
    link character varying,
    user_id bigint NOT NULL
);


ALTER TABLE public.user_recipe OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24583)
-- Name: user_recipe_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_recipe_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_recipe_id_seq OWNER TO postgres;

--
-- TOC entry 3639 (class 0 OID 0)
-- Dependencies: 219
-- Name: user_recipe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_recipe_id_seq OWNED BY public.user_recipe.id;


--
-- TOC entry 222 (class 1259 OID 24593)
-- Name: user_recipe_ratings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_recipe_ratings (
    id bigint NOT NULL,
    recipe_id bigint NOT NULL,
    user_id bigint NOT NULL,
    rating real NOT NULL
);


ALTER TABLE public.user_recipe_ratings OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24592)
-- Name: user_recipe_ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_recipe_ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_recipe_ratings_id_seq OWNER TO postgres;

--
-- TOC entry 3640 (class 0 OID 0)
-- Dependencies: 221
-- Name: user_recipe_ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_recipe_ratings_id_seq OWNED BY public.user_recipe_ratings.id;


--
-- TOC entry 3463 (class 2604 OID 16410)
-- Name: chat_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_history ALTER COLUMN id SET DEFAULT nextval('public.chat_history_id_seq'::regclass);


--
-- TOC entry 3468 (class 2604 OID 24642)
-- Name: recipe_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_type ALTER COLUMN id SET DEFAULT nextval('public.recipe_type_id_seq'::regclass);


--
-- TOC entry 3465 (class 2604 OID 24580)
-- Name: system_recipe id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_recipe ALTER COLUMN id SET DEFAULT nextval('public.system_recipe_id_seq'::regclass);


--
-- TOC entry 3466 (class 2604 OID 24587)
-- Name: user_recipe id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_recipe ALTER COLUMN id SET DEFAULT nextval('public.user_recipe_id_seq'::regclass);


--
-- TOC entry 3467 (class 2604 OID 24596)
-- Name: user_recipe_ratings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_recipe_ratings ALTER COLUMN id SET DEFAULT nextval('public.user_recipe_ratings_id_seq'::regclass);


--
-- TOC entry 3621 (class 0 OID 16407)
-- Dependencies: 216
-- Data for Name: chat_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat_history (id, context, last_update, user_id) FROM stdin;
1	123	2024-03-16 00:27:15.764279+08	\N
14	[{"role": "user", "content": " "}, {"role": "user", "content": "Please recommend a dish randomly selected by the system, the name of this dish is Easy Apple Slaw, please return it strictly in the following json format: {\\"dish_name\\": Easy Apple Slaw, \\"reason\\": the reason for recommending Easy Apple Slaw, \\"steps\\": a brief description of the process of making Easy Apple Slaw}"}, {"role": "assistant", "content": "{\\n    \\"dish_name\\": \\"Easy Apple Slaw\\",\\n    \\"reason\\": \\"Easy Apple Slaw is a refreshing and healthy side dish that is perfect for any occasion. It combines the crunchiness of apples with the tangy sweetness of a simple dressing.\\",\\n    \\"steps\\": \\"To make Easy Apple Slaw, start by thinly slicing apples and placing them in a bowl. Then, mix in some shredded cabbage, carrots, and a dressing made of mayonnaise, vinegar, sugar, and a pinch of salt. Toss everything together until well combined, and let it sit in the refrigerator for at least 30 minutes to allow the flavors to meld. Serve chilled and enjoy!\\" \\n}"}, {"role": "user", "content": "Please recommend a dish randomly selected by the system, the name of this dish is Basic Mashed Potatoes, please return it strictly in the following json format: {\\"dish_name\\": Basic Mashed Potatoes, \\"reason\\": the reason for recommending Basic Mashed Potatoes, \\"steps\\": a brief description of the process of making Basic Mashed Potatoes}"}, {"role": "assistant", "content": "{\\n    \\"dish_name\\": \\"Basic Mashed Potatoes\\",\\n    \\"reason\\": \\"Basic Mashed Potatoes are a classic comfort food that pairs well with a variety of main dishes. They are easy to make and loved by many for their creamy texture and buttery flavor.\\",\\n    \\"steps\\": \\"To make Basic Mashed Potatoes, start by peeling and chopping potatoes into equal-sized chunks. Boil the potatoes in salted water until they are fork-tender, then drain them and return them to the pot. Mash the potatoes using a potato masher or a hand mixer, adding butter, milk, salt, and pepper to taste. Continue mashing until you reach your desired consistency. Serve hot and enjoy with your favorite gravy or as a side dish!\\" \\n}"}, {"role": "user", "content": "Please recommend a dish randomly selected by the system, the name of this dish is Cioccolata Calda (Hot Chocolate Italian-Style), please return it strictly in the following json format: {\\"dish_name\\": Cioccolata Calda (Hot Chocolate Italian-Style), \\"reason\\": the reason for recommending Cioccolata Calda (Hot Chocolate Italian-Style), \\"steps\\": a brief description of the process of making Cioccolata Calda (Hot Chocolate Italian-Style)}"}, {"role": "assistant", "content": "{\\n    \\"dish_name\\": \\"Cioccolata Calda (Hot Chocolate Italian-Style)\\",\\n    \\"reason\\": \\"Cioccolata Calda is a rich and decadent Italian-style hot chocolate that is perfect for cold winter days or cozy evenings. It has a thick and creamy consistency thanks to the use of high-quality chocolate, making it a luxurious treat for chocolate lovers.\\",\\n    \\"steps\\": \\"To make Cioccolata Calda, start by heating milk and heavy cream in a saucepan over medium heat until it begins to simmer. Add finely chopped dark chocolate and cocoa powder to the mixture, stirring constantly until the chocolate is fully melted and the mixture is smooth and thick. Sweeten with sugar to taste, and optionally add a splash of vanilla extract or a pinch of cinnamon for extra flavor. Pour the hot chocolate into mugs and enjoy topped with whipped cream or marshmallows.\\" \\n}"}, {"role": "user", "content": "Please analyse the proposed nutritional analysis of the last dish mentioned above. Please return it strictly in the following json format, replace each value with your generated content, Only one text value per value position, do not use grouped values: {\\"target_group\\": analysis that what is the advice of different target people from a health and nutritional point of view, \\"analysis\\": a brief nutritional analysis of the dish.}"}, {"role": "assistant", "content": "{\\n    \\"target_group\\": \\"Cioccolata Calda is a rich and indulgent treat best enjoyed occasionally as a dessert or special treat due to its high calorie and sugar content.\\",\\n    \\"analysis\\": \\"Cioccolata Calda is a decadent beverage that is high in calories, saturated fat, and sugar due to the use of dark chocolate, heavy cream, and sugar in the recipe. While it provides some calcium and antioxidants from the dark chocolate, it is not a low-calorie or low-sugar option. It is best consumed in moderation as an occasional indulgence.\\" \\n}"}, {"role": "user", "content": "Please recommend a dish randomly selected by the system, the name of this dish is Classic Hash Browns, please return it strictly in the following json format: {\\"dish_name\\": Classic Hash Browns, \\"reason\\": the reason for recommending Classic Hash Browns, \\"steps\\": a brief description of the process of making Classic Hash Browns}"}, {"role": "assistant", "content": "{\\n    \\"dish_name\\": \\"Classic Hash Browns\\",\\n    \\"reason\\": \\"Classic Hash Browns are a delicious and comforting breakfast or brunch dish that is easy to make and versatile. They are crispy on the outside, soft on the inside, and can be customized with various seasonings or additions.\\",\\n    \\"steps\\": \\"To make Classic Hash Browns, start by shredding potatoes using a box grater or food processor. Squeeze out any excess moisture from the shredded potatoes using a clean kitchen towel. Heat butter or oil in a skillet over medium heat and add the shredded potatoes, spreading them out evenly. Let them cook without stirring for a few minutes to develop a crispy crust. Flip the hash browns and continue cooking until they are golden and crispy on both sides. Season with salt, pepper, and any desired herbs or spices. Serve hot and enjoy as a delicious side dish or breakfast option.\\" \\n}"}, {"role": "assistant", "content": "Here is the user_recipe information founded in the database:<strong>Juicy Roasted Chicken</strong> \\n<strong> \\ud83c\\udff7\\ufe0f Directions</strong> \\n  Preheat the oven to 350 degrees F (175 degrees C).\\n\\nPlace chicken in a roasting pan; season generously inside and out with onion powder, salt, and pepper. Place 3 tablespoons of butter in chicken cavity; arrange dollops of remaining butter on the outside of chicken. Cut celery into 3 or 4 pieces; place in the chicken cavity.\\n\\nBake chicken uncovered in the preheated oven until no longer pink at the bone and the juices run clear, about 1 hour and 15 minutes. An instant-read thermometer inserted into the thickest part of the thigh, near the bone, should read 165 degrees F (74 degrees C).\\n\\nRemove from the oven and baste with drippings. Cover with aluminum foil and allow to rest for about 30 minutes before serving. \\n \\n<strong> \\ud83d\\udd17 Reference Link</strong> \\n https://www.youtube.com/watch?v=EhrK8zwg-88"}, {"role": "assistant", "content": "Here is the user_recipe information founded in the database:<strong>Shrimp Scampi with Pasta</strong> \\n<strong> \\ud83c\\udff7\\ufe0f Directions</strong> \\n  Gather ingredients.\\n\\nOverhead view of all ingredients in various bowls and cups\\nBring a large pot of salted water to a boil; cook linguine in boiling water until nearly tender, 6 to 8 minutes. Drain.\\n\\nMelt 2 tablespoons butter with 2 tablespoons olive oil in a large skillet over medium heat.\\n\\nCook and stir shallots, garlic, and red pepper flakes in the hot butter and oil until shallots are translucent, 3 to 4 minutes.\\n\\nSeason shrimp with kosher salt and black pepper; add to the skillet and cook until pink, stirring occasionally, 2 to 3 minutes. Remove shrimp from skillet and keep warm.\\n\\nView from above of a pan with butter and minced ingredients and peeled shrimp\\nPour white wine and lemon juice into skillet and bring to a boil while scraping the browned bits of food off of the bottom of the skillet with a wooden spoon.\\n\\nMelt 2 tablespoons butter in skillet, stir 2 tablespoons olive oil into butter mixture, and bring to a simmer.\\n\\nToss linguine, shrimp, and parsley in the butter mixture until coated; season with salt and black pepper. Drizzle with 1 teaspoon olive oil to serve.\\n\\nhand with tongs mixing spaghetti, shrimp, and herbs in a pan\\nServe hot and enjoy!\\n \\n \\n<strong> \\ud83d\\udd17 Reference Link</strong> \\n https://www.youtube.com/watch?v=ybwmv5weeuM"}, {"role": "user", "content": "Please analyse the proposed nutritional analysis of the last dish mentioned above. Please return it strictly in the following json format, replace each value with your generated content, Only one text value per value position, do not use grouped values: {\\"target_group\\": analysis that what is the advice of different target people from a health and nutritional point of view, \\"analysis\\": a brief nutritional analysis of the dish.}"}, {"role": "assistant", "content": "{\\n    \\"target_group\\": \\"For individuals looking for a balanced meal with lean protein and moderate carbohydrates, this dish could be a suitable option. However, for those watching their cholesterol intake or sodium levels, it may be advisable to consume this dish in moderation.\\",\\n    \\"analysis\\": \\"Shrimp Scampi with Pasta is a dish that provides a good amount of lean protein from the shrimp and moderate carbohydrates from the pasta. The dish also contains healthy fats from olive oil. However, it can be high in sodium due to added salt and seasonings, as well as potentially high in cholesterol from the shrimp and butter. It is recommended to balance this dish with plenty of vegetables and consider portion sizes for overall health and nutrition.\\"\\n}"}]	2024-03-27 13:52:34.891444+08	6751692595
\.


--
-- TOC entry 3629 (class 0 OID 24639)
-- Dependencies: 224
-- Data for Name: recipe_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recipe_type (id, type) FROM stdin;
1	Breakfast
2	Lunch
3	Healthy
4	Appetizers
5	Salad
6	Side Dishes
7	Soup
8	Bread
9	Drinks
\.


--
-- TOC entry 3623 (class 0 OID 24577)
-- Dependencies: 218
-- Data for Name: system_recipe; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_recipe (id, recipe_name, type, style) FROM stdin;
1	Banana Zucchini Bread	1	null
2	Basted Eggs	1	null
3	Blender Hollandaise Sauce	1	null
4	Apple Fritter Pancakes	1	null
5	Brennan's Irish Soda Bread	1	null
6	Cinnamon Bread	1	null
7	Pan de Muertos (Mexican Bread of the Dead)	1	Mexican
8	Downeast Maine Pumpkin Bread	1	null
9	Clone of a Cinnabon	1	null
10	Cinnamon Toast	1	null
11	Hot Water Cornbread	1	null
12	English Muffins	1	null
13	90-Second Keto Bread in a Mug	1	null
14	Banana Sour Cream Bread	1	null
15	Blueberry Loaf	1	null
16	Cinnamon Swirl Bread	1	null
17	Cranberry Orange Bread	1	null
18	J.P.'s Big Daddy Biscuits	1	null
19	Easy Baking Powder Drop Biscuits	1	null
20	Real Homemade Bagels	1	null
21	Delicious Egg Salad	2	null
22	Sloppy Joes	2	null
23	Pasta Salad\n	2	null
24	Best Cream Of Broccoli Soup	2	null
25	Old-Fashioned Potato Salad	2	null
26	Grilled Cheese Sandwich	2	null
27	Fresh Tomato Soup	2	null
28	Marinated Cucumber, Onion, and Tomato Salad	2	null
29	Reuben Sandwich	2	null
30	Best Chicken Salad	2	null
31	Tomato Gorgonzola Soup	2	null
32	Super-Delicious Zuppa Toscana	2	null
33	Texas Caviar	3	null
34	Salt and Pepper Skillet Fries	3	null
35	Ezekiel Bread	3	null
36	Salsa	3	null
37	Granola Bars	3	null
38	D's Famous Salsa	3	null
39	Honey Whole Wheat Bread	3	null
40	Honey Wheat Bread II	3	null
41	Roti Bread from India	3	null
42	Beer Battered Onion Rings	3	null
43	Low-Fat Blueberry Bran Muffins	3	null
44	Playgroup Granola Bars	3	null
45	Healthier Buffalo Chicken Dip	3	null
46	Vegetarian Buffalo Chicken Dip	4	null
47	Easy Buffalo Chicken Dip	4	null
48	Buffalo Ranch Chicken and Cheese Dip	4	null
49	Hot Chicken Wing Dip	4	null
50	Blue Cheese Chicken Wing Dip	4	null
51	Chef John's Beef Sliders	4	null
52	Hawaiian Roll Roast Beef and Cheese Sandwiches\n	4	null
53	Cheesy Bacon Slider Bake	4	null
54	Philly Cheese Steak Sliders	4	null
55	Baked Ham and Cheese Sliders	4	null
56	Hawaiian Ham and Cheese Sliders	4	null
57	Almost White Castle Hamburgers	4	null
58	Slider-Style Mini Burgers	4	null
59	Philly Steak And Cheese Sliders	4	null
60	Grilled Chicken Pineapple Sliders	4	null
61	Napa Cabbage Salad	5	null
62	Best Ramen Noodle Salad	5	null
63	Traditional Creamy Coleslaw	5	null
64	Southern Coleslaw	5	null
65	Red Cabbage Slaw	5	null
66	Asian Coleslaw	5	null
67	Red Cabbage Salad	5	null
68	Easy Apple Slaw	5	null
69	Susan's Vinaigrette Coleslaw	5	null
70	Ramen Coleslaw	5	null
71	Crunchy Ramen Cabbage Salad	5	null
72	Hawaiian Cole Slaw	5	null
73	Creamy Spiced Coleslaw	5	null
74	Ramen Cabbage Salad	5	null
75	Taco Slaw	5	null
76	Bubble and Squeak	6	null
77	Microwave Baked Potato	6	null
78	Basic Mashed Potatoes	6	null
79	Creamy au Gratin Potatoes	6	null
80	Ultimate Twice-Baked Potatoes	6	null
81	Homemade Crispy Hash Browns	6	null
82	Air Fryer Potato Wedges	6	null
83	Potato Pancakes	6	null
84	Old-Fashioned Potato Cakes	6	null
85	Easy Irish Colcannon	6	null
86	Fried Mashed Potato Cakes	6	null
87	Quick and Easy Home Fries	6	null
88	Roasted New Red Potatoes	6	null
89	Classic Hash Browns	6	null
90	Scalloped Potatoes	6	null
91	Lemon Chicken Orzo Soup	7	null
92	Homemade Chicken Soup	7	null
93	Slow Cooker Chicken and Dumplings	7	null
94	Quick and Easy Chicken Noodle Soup	7	null
95	Mulligatawny Soup	7	null
96	Incredibly Easy Chicken and Noodles	7	null
97	Mulligatawny Soup	7	null
98	Slow Cooker Chicken Taco Soup	7	null
99	Slow-Cooker Chicken Tortilla Soup	7	null
100	Super-Delicious Zuppa Toscana	7	null
101	Copycat Panera Broccoli Cheddar Soup	7	null
102	Slow Cooker Taco Soup	7	null
103	Rich and Simple French Onion Soup	7	null
104	Miso Soup	7	null
105	Butternut Squash Soup	7	null
106	Easy Homemade Pizza Dough	8	null
107	Banana Chocolate Chip Bread	8	null
108	Mom's Zucchini Bread	8	null
109	Banana Muffins	8	null
110	Homemade Flour Tortillas	8	null
111	Janet's Rich Banana Bread	8	null
112	Best Bread Machine Bread	8	null
113	Best Monkey Bread	8	null
114	Downeast Maine Pumpkin Bread	8	null
115	French Baguettes	8	null
116	Hot Cross Buns	8	null
117	Cinnamon Swirl Bread for the Bread Machine	8	null
118	Bread Machine Thin Crust Pizza Dough	8	null
119	Softest Soft Bread with Air Pockets Using Bread Machine	8	null
120	Bread Machine Bagels	8	null
121	Cioccolata Calda (Hot Chocolate Italian-Style)	9	null
122	Creamy Homemade Hot Cocoa	9	null
123	Snow Flake Cocoa	9	null
124	Creamy Hot Chocolate	9	null
125	Hot Cocoa Mix in a Jar	9	null
126	Hot Spiced Cider	9	null
127	Homemade Apple Cider	9	null
128	Easy Apple Cider	9	null
129	Homemade Hot Apple Cider	9	null
130	Apple Pie in a Jar Drink	9	null
131	Hot Spiced Cranberry Cider	9	null
132	The REAL Long Island Iced Tea	9	null
133	The Real Mojito	9	null
134	Best Strawberry Daiquiri	9	null
135	Bahama Mama	9	null
\.


--
-- TOC entry 3625 (class 0 OID 24584)
-- Dependencies: 220
-- Data for Name: user_recipe; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_recipe (id, recipe_name, directions, rating, link, user_id) FROM stdin;
2	Playgroup Granola Bars	Preheat the oven to 350 degrees F (175 degrees C). Generously grease a 9x13 inch baking pan.\n\nIn a large bowl, mix together the oats, brown sugar, wheat germ, cinnamon, flour, raisins and salt. Make a well in the center, and pour in the honey, egg, oil and vanilla. Mix well using your hands. Pat the mixture evenly into the prepared pan.\n\nBake for 30 to 35 minutes in the preheated oven, until the bars begin to turn golden at the edges. Cool for 5 minutes, then cut into bars while still warm. Do not allow the bars to cool completely before cutting, or they will be too hard to cut.	5	https://www.youtube.com/watch?v=AVy_uHZ8s-g	6751692595
3	Slow Cooker Texas Pulled Pork	Pour vegetable oil into the bottom of a slow cooker. Place pork roast into the slow cooker; pour in barbeque sauce, vinegar, and chicken broth. Stir in brown sugar, yellow mustard, Worcestershire sauce, chili powder, onion, garlic, and thyme. Cover and cook on Low for 10 to 12 hours or High for 5 to 6 hours until pork shreds easily with a fork.\n\nRemove pork from the slow cooker, and shred the meat using two forks. Return shredded pork to the slow cooker, and stir to combine with juices.\n\nSpread the inside of both halves of hamburger buns with butter. Toast buns, butter-side down, in a skillet over medium heat until golden brown. Spoon pulled pork into toasted buns.\n\n	5	https://www.youtube.com/watch?v=k8TEV8AZGTo	6751692595
24	Baked Ziti	Bring a large pot of lightly salted water to a boil. Add ziti pasta, and cook until al dente, about 8 minutes; drain.\n\nMeanwhile, brown ground beef and onion in a large skillet over medium heat; stir in spaghetti sauce and simmer for 15 minutes.\n\nPreheat the oven to 350 degrees F (175 degrees C). Butter a 9x13-inch baking dish.\n\nSpread 1/2 of the ziti in the bottom of the prepared dish; top with Provolone cheese, sour cream, 1/2 of the meat sauce, remaining ziti, mozzarella cheese, and remaining meat sauce. Top with grated Parmesan cheese.\n\nBake in the preheated oven until heated through and cheeses have melted, about 30 minutes.	5	https://www.youtube.com/watch?v=MB_FFYq_mr0	6751692595
35	Manicotti	Cook manicotti in boiling water until al dente, about 10 to 12 minutes; drain and rinse with cold water.\n\nPreheat oven to 350 degrees F (175 degrees C).\n\nMix ricotta, mozzarella, 1/2 cup Parmesan cheese, eggs, parsley, salt, and pepper in a large bowl until well combined.\n\nPour 1/2 cup spaghetti sauce into an 11x17-inch baking dish. Stuff each manicotti shell with 3 tablespoons cheese mixture, and arrange over sauce. Pour remaining sauce over the top of the shells and sprinkle with remaining Parmesan cheese.\n\nBake in the preheated oven until bubbly, about 45 minutes.	5	https://www.youtube.com/watch?v=eUn2UfL7VZQ	6751692595
26	Juicy Roasted Chicken	Preheat the oven to 350 degrees F (175 degrees C).\n\nPlace chicken in a roasting pan; season generously inside and out with onion powder, salt, and pepper. Place 3 tablespoons of butter in chicken cavity; arrange dollops of remaining butter on the outside of chicken. Cut celery into 3 or 4 pieces; place in the chicken cavity.\n\nBake chicken uncovered in the preheated oven until no longer pink at the bone and the juices run clear, about 1 hour and 15 minutes. An instant-read thermometer inserted into the thickest part of the thigh, near the bone, should read 165 degrees F (74 degrees C).\n\nRemove from the oven and baste with drippings. Cover with aluminum foil and allow to rest for about 30 minutes before serving.	5	https://www.youtube.com/watch?v=EhrK8zwg-88	6751692595
27	Chicken Pot Pie	Make the Filling\nBoil the cubed chicken with the carrots, peas, and celery for about 15 minutes. Drain and set aside. Cook the onions in butter until they're translucent, then stir in the flour and seasonings. Add the chicken broth and milk and simmer until the filling is thick.\n\nFill and Bake the Pie\nPlace the chicken-vegetable mixture in an unbaked pie crust. Pour the chicken broth mixture over it. Cover with the top crust, seal the edges, and cut slits in the top to allow the steam to escape. Bake until the pastry is golden brown and the filling is bubbly.	5	https://www.youtube.com/watch?v=9BPofD8uuzQ	6751692595
28	Easy Meatloaf	Preheat the oven to 350 degrees F (175 degrees C). Lightly grease a 9x5-inch loaf pan.\n\nCombine ground beef, onion, milk, bread crumbs and egg in a large bowl; season with salt and pepper. Transfer into prepared loaf pan.\n\nMix ketchup, brown sugar, and mustard together in a small bowl until well combined; pour over meatloaf and spread it evenly over the top.\n\nBake in the preheated oven until no longer pink in the center, about 1 hour.	5	https://www.youtube.com/watch?v=IIF3bhR_59M	6751692595
30	Slow-Cooker Corned Beef and Cabbage	Place potatoes, carrots, and onion into the bottom of a slow cooker; add water and place brisket on top of vegetables. Pour beer over brisket; sprinkle over spices from the packet and cover.\n\nCook on High for 7 hours; stir in the cabbage and cook for 1 more hour.\n\n	5	https://www.youtube.com/watch?v=Xy89ltRgwBM	6751692595
31	Simple Macaroni and Cheese	Bring a large pot of lightly salted water to a boil. Cook elbow macaroni in the boiling water, stirring occasionally until cooked through but firm to the bite, 8 minutes.\n\nElbow macaroni cooking in boiling water\nAt the same time, melt butter in a saucepan over medium heat.\n\nAdd flour, salt, and pepper and stir until smooth, about 5 minutes.\n\nPour in milk slowly, while stirring continuously. Continue to cook and stir until mixture is smooth and bubbling, about 5 minutes, making sure the milk doesn't burn.\n\nAdd Cheddar cheese and stir until melted, 2 to 4 minutes.\n\nCheese being whisked into roux\n\nDrain macaroni and fold into cheese sauce until coated.\n\nFolding pasta into cheese sauce\nServe hot and enjoy!\n	5	https://www.youtube.com/watch?v=IzLn0pXntNE	6751692595
32	Chef John's Perfect Prime Rib	Place prime rib roast on a plate and bring to room temperature, 2 to 4 hours.\n\nPreheat the oven to 500 degrees F (260 degrees C).\n\nCombine butter, pepper, and herbes de Provence in a bowl; mix until well blended. Spread butter mixture evenly over entire roast. Season roast generously with kosher salt.\n\nRoast the 4-pound roast in the preheated oven for 20 minutes. (If your roast is larger or smaller than 4 pounds, multiply the exact weight times 5 minutes.)\n\nTurn the oven off and, leaving the roast in the oven with the door closed, let the roast sit in the oven for 2 hours.\n\nRemove roast from the oven, slice, and serve.	5	https://www.youtube.com/watch?v=FbuCSgiDNhQ	6751692595
33	Spaghetti Aglio e Olio	Bring a large pot of lightly salted water to a boil. Cook spaghetti in the boiling water, stirring occasionally until cooked through but firm to the bite, about 10 to 12 minutes. Drain and transfer to a pasta bowl.\n\nWhile the pasta is cooking, combine olive oil and garlic in a cold skillet. Cook over medium heat to slowly toast garlic, about 10 minutes. Reduce heat to medium-low when olive oil begins to bubble. Cook and stir until garlic is golden brown, about another 5 minutes. Remove from heat.\n\nStir red pepper flakes, salt, and black pepper into pasta. Pour in hot olive oil and garlic, and sprinkle on Italian parsley and half of the Parmigiano-Reggiano cheese; toss until combined.\n\nServe pasta topped with the remaining Parmigiano-Reggiano cheese.	5	https://www.youtube.com/watch?v=HJnu_7sywdI	6751692595
21	Best Tuna Casserole	Gather all ingredients.\n\nA top down view of all ingredients, prepped and measured, for the best tuna casserole.\nFill a large pot with lightly salted water and bring to a rapid boil. Cook egg noodles at a boil until tender yet firm to the bite, 7 to 9 minutes; drain.\n\nMeanwhile, preheat the oven to 425 degrees F (220 degrees C).\n\nMix noodles, condensed soup, 1 cup cheese, tuna, peas, mushrooms, and onion in a large bowl until well combined.\n\nAll ingredients for tuna casserole in a large mixing bowl, unmixed.\nTransfer the mixture into a 9x13-inch baking dish.\n\nCombined tuna mixture in a white casserole dish.\nTop the mixture with crushed potato chip and remaining 1 cup of cheese.\n\nTuna casserole mixture in white baking dish topped with potato chips.\nTuna casserole mixture in a white baking dish topped with potato chips and shredded cheddar.\nBake in the preheated oven until cheese is bubbly, about 15 to 20 minutes.\n\nAn overhead view of the best tuna casserole, baked until cheesy top is melted and bubbly.\nServe hot and enjoy!	5	https://www.youtube.com/watch?v=gsE7qmafGCw	6751692595
34	Chicken Parmesan	Preheat an oven to 450 degrees F (230 degrees C).\n\nPlace chicken breasts between two sheets of heavy plastic (resealable freezer bags work well) on a solid, level surface. Firmly pound chicken with the smooth side of a meat mallet to a thickness of 1/2-inch.\n\nSeason chicken thoroughly with salt and pepper. Using a sifter or strainer; sprinkle flour over chicken breasts, evenly coating both sides\n\nChicken breasts pounded to 1/2 inch thickness, seasoned with salt and pepper and coated in flour\nDOTDASH MEREDITH FOOD STUDIOS\nBeat eggs in a shallow bowl and set aside.\n\nMix bread crumbs and 1/2 cup Parmesan cheese in a separate bowl, set aside.\n\nDip a flour-coated chicken breast in beaten eggs. Transfer breast to the bread crumb mixture, pressing crumbs into both sides. Repeat for each breast. Let chicken rest for 10 to 15 minutes.\n\nHeat 1/2 inch olive oil in a large skillet on medium-high heat until it begins to shimmer. Cook chicken in the hot oil until golden, about 2 minutes per side. The chicken will finish cooking in the oven.\n\nChicken breast frying in hot oil in a skillet\n\nTransfer chicken to a baking dish. Top each breast with 2 tablespoons tomato sauce. Layer each chicken breast with equal amounts of mozzarella cheese, fresh basil, and provolone cheese. Sprinkle remaining Parmesan over top and drizzle each with 1/2 teaspoon olive oil.\n\nBake in the preheated oven until cheese is browned and bubbly and chicken breasts are no longer pink in the center, 15 to 20 minutes. An instant-read thermometer inserted into the center should read at least 165 degrees F (74 degrees C).\n\nFresh out of the oven chicken parmesan topped with gooey mozzarella and parmesan cheese.\n	5	https://www.youtube.com/watch?v=gwSOwAe_IVY	6751692595
36	Juicy Thanksgiving Turkey	Gather all ingredients. Preheat the oven to 350 degrees F (175 degrees C). Line a roaster with sheets of aluminum foil long enough to wrap around turkey.\n\nChopped vegetables, seasonings, sliced citrus and an uncooked turkey on a stone surface.\n\nStir parsley, rosemary, sage, thyme, lemon-pepper seasoning, and salt together in a small bowl.\n\nDried herbs in a bowl with a small whisk.\n\nRub herb mixture into turkey cavity, then stuff with orange wedges, onion, carrot, and celery. Tie turkey legs together with kitchen string, then tuck the wings under the body.\n\nUncooked turkey stuffed with seasonings a fresh citrus wedges. \n\nPlace turkey on the foil in the roasting pan. Pour champagne and chicken broth over turkey, making sure to get some liquid in the cavity.\n\nUncooked turkey in a foiled lined roasting pan.\nBring aluminum foil up and over the top of turkey and seal; try to keep the foil from touching the turkey.\n\nRoast turkey in the preheated oven until juices run clear, 2 ½ to 3 hours. Uncover turkey and continue baking until the skin turns golden brown, 30 to 60 more minutes. An instant-read thermometer inserted into the thickest part of thigh, near the bone, should read 180 degrees F (82 degrees C).\n\nA person taking the temperature of a roasted turkey in a foiled lined roasting pan.\n\nRemove turkey from the oven, cover with two sheets of aluminum foil, and allow to rest in a warm area before slicing, 10 to 15 minutes.\n\nA person uncovering a roasted turkey.\nALLRECIPES / KAREN HIBBARD\nServe and enjoy!\n	5	https://www.youtube.com/watch?v=a9WU7hag6W4	6751692595
38	Oven-Roasted Turkey Breast	Preheat the oven to 350 degrees F (175 degrees C).\n\nMix 1/4 cup butter, garlic, paprika, Italian seasoning, garlic and herb seasoning, salt, and black pepper together in a bowl.\n\nPlace turkey breast with skin-side up into a roasting pan. Loosen skin with your fingers; brush 1/2 of the butter mixture over the turkey breast and underneath the skin. Reserve remaining butter mixture. Tent turkey breast loosely with aluminum foil.\n\nRoast in the preheated oven for 1 hour; baste turkey breast with remaining butter mixture. Return to oven and roast until the juices run clear and an instant-read meat thermometer inserted into the thickest part of the breast, not touching bone, reads 165 degrees F (65 degrees C), about 30 more minutes. Let turkey breast rest 10 to 15 minutes before serving.\n\nWhile turkey is resting, transfer pan drippings to a skillet. Skim off excess grease, leaving about 1 tablespoon in skillet. Place skillet over low heat; cook and stir shallot in turkey grease until opaque, about 5 minutes.\n\nMelt 1 tablespoon butter in skillet with shallot and whisk in white wine, scraping any browned bits of food from skillet. Whisk in chicken stock and flour until smooth. Bring to a simmer, whisking constantly, until thickened. For a creamier, lighter gravy, whisk in half-and-half.\n\nServe hot and enjoy!	5	https://www.youtube.com/watch?v=yPCGiPqph1I	6751692595
22	Authentic Louisiana Red Beans and Rice	Gather all ingredients.\n\nRinse beans, and then soak in a large pot of water overnight.\n\nHeat oil in a skillet over medium heat. Cook onion, bell pepper, celery, and garlic in olive oil for 3 to 4 minutes.\n\nRinse beans, and transfer to a large pot with 6 cups water. Stir cooked vegetables into beans. Season with bay leaves, parsley, thyme, Cajun seasoning, cayenne pepper, and sage. Bring to a boil, and then reduce heat to medium-low. Simmer for 2 1/2 hours.\n\nDOTDASH MEREDITH FOOD STUDIO\nStir sausage into beans, and continue to simmer for 30 minutes.\n\nMeanwhile, prepare the rice. Bring water and rice to a boil in a saucepan. Reduce heat, cover, and simmer for 20 minutes. Serve beans over steamed white rice.	5	https://www.youtube.com/watch?v=Q6xd8IO9o3I	6751692595
23	Hamburger Steak with Onions and Gravy	Gather all ingredients.\n\nMix ground beef, bread crumbs, egg, Worcestershire sauce, salt, onion powder, garlic powder, and pepper together in a large bowl until combined. Form into 8 balls and flatten into patties.\n\nHeat oil in a large skillet over medium heat. Add patties and onion; fry until patties are nicely browned, about 4 minutes per side. Transfer beef patties to a plate, and keep warm.\n\nSprinkle flour over onions and drippings in the skillet. Stir in flour with a fork, scraping bits of beef off of the bottom of the skillet as you stir. Gradually mix in beef broth and sherry. Season with seasoned salt. Simmer and stir over medium-low heat until gravy thickens, about 5 minutes.\n\nReduce heat to low, return patties to the gravy, cover, and simmer until cooked through, about 15 minutes.\n\nServe and enjoy!	5	https://www.youtube.com/watch?v=BNeEFbfzw6s	6751692595
25	Shrimp Scampi with Pasta	Gather ingredients.\n\nOverhead view of all ingredients in various bowls and cups\nBring a large pot of salted water to a boil; cook linguine in boiling water until nearly tender, 6 to 8 minutes. Drain.\n\nMelt 2 tablespoons butter with 2 tablespoons olive oil in a large skillet over medium heat.\n\nCook and stir shallots, garlic, and red pepper flakes in the hot butter and oil until shallots are translucent, 3 to 4 minutes.\n\nSeason shrimp with kosher salt and black pepper; add to the skillet and cook until pink, stirring occasionally, 2 to 3 minutes. Remove shrimp from skillet and keep warm.\n\nView from above of a pan with butter and minced ingredients and peeled shrimp\nPour white wine and lemon juice into skillet and bring to a boil while scraping the browned bits of food off of the bottom of the skillet with a wooden spoon.\n\nMelt 2 tablespoons butter in skillet, stir 2 tablespoons olive oil into butter mixture, and bring to a simmer.\n\nToss linguine, shrimp, and parsley in the butter mixture until coated; season with salt and black pepper. Drizzle with 1 teaspoon olive oil to serve.\n\nhand with tongs mixing spaghetti, shrimp, and herbs in a pan\nServe hot and enjoy!\n	5	https://www.youtube.com/watch?v=ybwmv5weeuM	6751692595
29	Stuffed Peppers	Gather all ingredients, and preheat the oven to 350 degrees F (175 degrees C).\n\nBring water and rice to a boil in a covered saucepan. Reduce heat to low and simmer until rice is tender, about 20 minutes.\n\nMeanwhile, heat oil in a skillet over medium heat. Add ground beef and cook until evenly browned and crumbly, 7 to 9 minutes.\n\nHollow out bell peppers by removing and discarding the tops, seeds, and membranes. Slice the bottoms of the peppers if necessary to make sure they stand up straight.\n\nArrange peppers in a baking dish with the hollowed sides facing upward.\n\nPrepare filling by mixing cooked beef, cooked rice, 1/2 of the tomato sauce, Worcestershire sauce, garlic powder, onion powder, salt, and pepper. Spoon an equal amount of filling into each hollowed pepper.\n\nMix remaining tomato sauce and Italian seasoning in a bowl, and pour over the stuffed peppers.\n\nBake in the preheated oven, basting with sauce every 15 minutes, until peppers are tender, about 1 hour.\nServe hot and enjoy!\n	5	https://www.youtube.com/watch?v=ektsiKFVqks	6751692595
37	Slow-Cooker Pepper Steak	Sprinkle beef sirloin strips with garlic powder. Heat vegetable oil in a large skillet over medium heat and sear beef strips, about 5 minutes per side. Transfer to a slow cooker.\n\nMix bouillon cube with hot water in a separate container until dissolved, then mix in cornstarch until dissolved. Pour into the slow cooker with beef strips. Stir in onion, green peppers, stewed tomatoes, soy sauce, sugar, and salt.\n\nCover, and cook on High for 3 to 4 hours, or on Low for 6 to 8 hours.	5	https://www.youtube.com/watch?v=6IzOtOiSqHY	6751692595
\.


--
-- TOC entry 3627 (class 0 OID 24593)
-- Dependencies: 222
-- Data for Name: user_recipe_ratings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_recipe_ratings (id, recipe_id, user_id, rating) FROM stdin;
\.


--
-- TOC entry 3641 (class 0 OID 0)
-- Dependencies: 215
-- Name: chat_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chat_history_id_seq', 14, true);


--
-- TOC entry 3642 (class 0 OID 0)
-- Dependencies: 223
-- Name: recipe_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recipe_type_id_seq', 9, true);


--
-- TOC entry 3643 (class 0 OID 0)
-- Dependencies: 217
-- Name: system_recipe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.system_recipe_id_seq', 135, true);


--
-- TOC entry 3644 (class 0 OID 0)
-- Dependencies: 219
-- Name: user_recipe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_recipe_id_seq', 38, true);


--
-- TOC entry 3645 (class 0 OID 0)
-- Dependencies: 221
-- Name: user_recipe_ratings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_recipe_ratings_id_seq', 1, false);


--
-- TOC entry 3470 (class 2606 OID 16414)
-- Name: chat_history chat_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_history
    ADD CONSTRAINT chat_history_pkey PRIMARY KEY (id);


--
-- TOC entry 3476 (class 2606 OID 24646)
-- Name: recipe_type recipe_type_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_type
    ADD CONSTRAINT recipe_type_pk PRIMARY KEY (id);


--
-- TOC entry 3472 (class 2606 OID 24589)
-- Name: user_recipe user_recipe_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_recipe
    ADD CONSTRAINT user_recipe_pk PRIMARY KEY (id);


--
-- TOC entry 3474 (class 2606 OID 24598)
-- Name: user_recipe_ratings user_recipe_ratings_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_recipe_ratings
    ADD CONSTRAINT user_recipe_ratings_pk PRIMARY KEY (id);


-- Completed on 2024-03-27 15:12:09 HKT

--
-- PostgreSQL database dump complete
--

