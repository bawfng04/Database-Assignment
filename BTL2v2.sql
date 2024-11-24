--Người dùng hệ thống
CREATE TABLE Users(
    Username_ID INT PRIMARY KEY,
    User_Email VARCHAR(255),
    User_Phone_Number INT,
    User_Password VARCHAR(255),
    User_Address VARCHAR(255),
    User_Image TEXT,
    User_Name VARCHAR(255),
)

--Admin
CREATE TABLE Admin(
    Admin_ID INT PRIMARY KEY,

    FOREIGN KEY (Admin_ID) REFERENCES Users(Username_ID) ON DELETE CASCADE,
)

-- Giảng viên
CREATE TABLE Teacher(
    Teacher_ID INT PRIMARY KEY,
    Teacher_Description TEXT,

    FOREIGN KEY (Teacher_ID) REFERENCES Users(Username_ID) ON DELETE CASCADE,
);

--Giỏ hàng
CREATE TABLE Cart(
    Cart_ID INT PRIMARY KEY,
    Student_ID INT,
);

-- Phiếu giảm giá
CREATE TABLE Coupon(
    Coupon_ID INT PRIMARY KEY,
    Coupon_title VARCHAR(255),
    Coupon_Value INT,
    Coupon_Type VARCHAR(255),
    Coupon_Start_Date DATE,
    Coupon_Expiry_Date DATE,
    Coupon_Max_Discount INT,
);

--Học viên
CREATE TABLE Student(
    Student_ID INT PRIMARY KEY,
    Student_Cart_ID INT,

    FOREIGN KEY (Student_Cart_ID) REFERENCES Cart(Cart_ID) ON DELETE CASCADE,
    FOREIGN KEY (Student_ID) REFERENCES Users(Username_ID) ON DELETE CASCADE,
);

-- Bảng danh mục
CREATE TABLE Categories (
    Categories_ID INT PRIMARY KEY,
    Categories_Name VARCHAR(255),
    Categories_Description TEXT,
);


--Khoá học
CREATE TABLE Course(
    Course_ID INT PRIMARY KEY,
    Course_Name VARCHAR(255),
    Course_Status VARCHAR(255),
    Course_Description TEXT,
    Course_Price INT,
    Course_Image TEXT,
    Course_Start_Date DATE,
    Course_End_Date DATE,
    Course_Categories_ID INT,

    FOREIGN KEY (Course_Categories_ID) REFERENCES Categories(Categories_ID) ON DELETE CASCADE,
);


-- Bảng chỉnh sửa
CREATE TABLE Edit (
    Edit_ID INT PRIMARY KEY,
    Edit_Time DATETIME DEFAULT CURRENT_TIMESTAMP,
    Edit_Content TEXT,
    Edit_Admin_ID INT,
    Edit_Coupon_ID INT,
    EDIT_Course_ID INT,

    FOREIGN KEY (Edit_Admin_ID) REFERENCES Admin(Admin_ID) ON DELETE CASCADE,
    FOREIGN KEY (Edit_Coupon_ID) REFERENCES Coupon(Coupon_ID) ON DELETE CASCADE,
    FOREIGN KEY (Edit_Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
);

--Giảng viên dạy khoá học
CREATE TABLE Teacher_Course(
    Teacher_ID INT,
    Course_ID INT,

    PRIMARY KEY (Teacher_ID, Course_ID),
    FOREIGN KEY (Teacher_ID) REFERENCES Teacher(Teacher_ID) ON DELETE CASCADE,
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
);

--Khoá học áp dụng phiếu giảm giá
CREATE TABLE Course_Coupon(
    Course_ID INT,
    Coupon_ID INT,
    PRIMARY KEY (Course_ID, Coupon_ID),

    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
    FOREIGN KEY (Coupon_ID) REFERENCES Coupon(Coupon_ID) ON DELETE CASCADE,
);


--Khoá học được thêm vào giỏ hàng
CREATE TABLE Course_Cart(
    Course_ID INT,
    Cart_ID INT,
    PRIMARY KEY (Course_ID, Cart_ID),

    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
    FOREIGN KEY (Cart_ID) REFERENCES Cart(Cart_ID) ON DELETE CASCADE,
);


--Khoá học có học viên
CREATE TABLE Course_Student(
    Course_ID INT,
    Student_ID INT,
    PRIMARY KEY (Course_ID, Student_ID),

    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE,
);


--Phương thức thanh toán
CREATE TABLE Payment_Method(
    Payment_Method_ID INT PRIMARY KEY,
    Payer_Name VARCHAR(255),
    Payment_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
);

--Momo
CREATE TABLE Momo(
    Momo_ID INT PRIMARY KEY, --mã thanh toán
    Momo_Phone_Number INT,

    FOREIGN KEY (Momo_ID) REFERENCES Payment_Method(Payment_Method_ID) ON DELETE CASCADE,
);

--Internet banking
CREATE TABLE Internet_Banking(
    Internet_Banking_ID INT PRIMARY KEY, --mã thanh toán
    Internet_Banking_Bank_Name VARCHAR(255),

    FOREIGN KEY (Internet_Banking_ID) REFERENCES Payment_Method(Payment_Method_ID) ON DELETE CASCADE,
);

--Visa
CREATE TABLE Visa(
    Visa_ID INT PRIMARY KEY, --mã thanh toán
    Visa_Card_Number INT, --số thẻ
    Visa_Expiry_Date DATE, --ngày hết hạn

    FOREIGN KEY (Visa_ID) REFERENCES Payment_Method(Payment_Method_ID) ON DELETE CASCADE,
);

--Đơn hàng
CREATE TABLE Orders (
    Orders_ID INT PRIMARY KEY,
    Orders_Payment_Status VARCHAR(255),
    Orders_Time DATETIME DEFAULT CURRENT_TIMESTAMP,
    Payment_ID INT, --mã thanh toán
    Student_ID INT, --mã học viên

    FOREIGN KEY (Payment_ID) REFERENCES Payment_Method(Payment_Method_ID) ON DELETE CASCADE,
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE,
);

--Khoá học được thêm vào đơn hàng
CREATE TABLE Course_Order(
    Course_ID INT,
    Order_ID INT,
    PRIMARY KEY (Course_ID, Order_ID),

    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
    FOREIGN KEY (Order_ID) REFERENCES Orders(Orders_ID) ON DELETE CASCADE,
);

--Đánh giá
CREATE TABLE Reviews (
    Reviews_ID INT,
    Course_ID INT,
    Reviews_Score INT,
    Reviews_Content TEXT,
    Student_ID INT,
    PRIMARY KEY (Reviews_ID, Course_ID),

    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE,
);


--Người đại diện
CREATE TABLE Guardians(
    Guardians_ID INT,
    Student_ID INT,
    Guardians_Name VARCHAR(255),
    Guardians_Email VARCHAR(255),
    Guardians_Phone_Number INT,
    PRIMARY KEY (Guardians_ID, Student_ID),

    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE,
)

--Chương
CREATE TABLE Chapter(
    Chapter_Name VARCHAR(255),
    Course_ID INT,
    PRIMARY KEY (Chapter_Name, Course_ID),
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE
);

--Bài học
CREATE TABLE Lesson (
    Lesson_Order INT,
    Course_ID INT,
    Chapter_Name VARCHAR(255),
    Lesson_Title VARCHAR(255),
    Lesson_Content TEXT,
    Lesson_Duration INT,
    PRIMARY KEY (Lesson_Order, Course_ID, Chapter_Name),
    FOREIGN KEY (Chapter_Name, Course_ID) REFERENCES Chapter(Chapter_Name, Course_ID) ON DELETE CASCADE
)

--Bài tập
CREATE TABLE Exercise(
    Exercise_Order INT,
    Lesson_Order INT,
    Course_ID INT,
    Chapter_Name VARCHAR(255),
    Exercise_Title VARCHAR(255),
    Exercise_Solution TEXT,
    Exercise_Number_Of_Correct_Answers INT,
    Exercise_Content TEXT,

    PRIMARY KEY (Exercise_Order, Lesson_Order, Course_ID, Chapter_Name),

    FOREIGN KEY (Lesson_Order, Course_ID, Chapter_Name) REFERENCES Lesson(Lesson_Order, Course_ID, Chapter_Name) ON DELETE CASCADE,
)

--Tài liệu
CREATE TABLE Document(
    Document_ID INT PRIMARY KEY,
    Course_ID INT,
    Chapter_Name VARCHAR(255),
    Document_Author VARCHAR(255),
    Document_Title VARCHAR(255),
    Document_Size INT,
    Document_Type VARCHAR(255),
    FOREIGN KEY (Chapter_Name, Course_ID) REFERENCES Chapter(Chapter_Name, Course_ID) ON DELETE CASCADE
)

--Bài kiểm tra
CREATE TABLE Test(
    Test_Order INT,
    Chapter_Name VARCHAR(255),
    Course_ID INT,
    Test_Number_Of_Questions INT,
    Test_Solution TEXT,
    Test_TakenTimes INT,
    Test_Number_Of_Correct_Answers INT,
    Test_Content TEXT,

    PRIMARY KEY (Test_Order, Chapter_Name, Course_ID),

    FOREIGN KEY (Chapter_Name, Course_ID) REFERENCES Chapter(Chapter_Name, Course_ID) ON DELETE CASCADE
)