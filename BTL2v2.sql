


-- Bảng chỉnh sửa
CREATE TABLE Edit (
    Edit_ID INT PRIMARY KEY,
    Edit_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Edit_Content TEXT,
    Edit_Admin_ID INT,
    Edit_Coupon_ID INT,
    EDIT_Course_ID INT,


);

-- Bảng danh mục
CREATE TABLE Categories (
    Categories_ID INT PRIMARY KEY,
    Categories_Name VARCHAR(255),
    Categories_Description TEXT,
);

-- Giảng viên
CREATE TABLE Teacher(
    Teacher_ID INT PRIMARY KEY,
    Teacher_Description TEXT,
);

--Giảng viên dạy khoá học
CREATE TABLE Teacher_Course(
    Teacher_ID INT,
    Course_ID INT,
    PRIMARY KEY (Teacher_ID, Course_ID),
);

--Khoá học áp dụng phiếu giảm giá
CREATE TABLE Course_Coupon(
    Course_ID INT,
    Coupon_ID INT,
    PRIMARY KEY (Course_ID, Coupon_ID),
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
);


--Khoá học được thêm vào giỏ hàng
CREATE TABLE Course_Cart(
    Course_ID INT,
    Cart_ID INT,
    PRIMARY KEY (Course_ID, Cart_ID),
);


--Giỏ hàng
CREATE TABLE Cart(
    Cart_ID INT PRIMARY KEY,
    Student_ID INT,
);

--Khoá học có học viên
CREATE TABLE Course_Student(
    Course_ID INT,
    Student_ID INT,
    PRIMARY KEY (Course_ID, Student_ID),
);


--Phương thức thanh toán
CREATE TABLE Payment_Method(
    Payment_Method_ID INT PRIMARY KEY,
    Payer_Name VARCHAR(255),
    Payment_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

--Momo
CREATE TABLE Momo(
    Momo_ID INT PRIMARY KEY, --mã thanh toán
    Momo_Phone_Number INT,
);

--Internet banking
CREATE TABLE Internet_Banking(
    Internet_Banking_ID INT PRIMARY KEY, --mã thanh toán
    Internet_Banking_Bank_Name VARCHAR(255),
);

--Visa
CREATE TABLE Visa(
    Visa_ID INT PRIMARY KEY, --mã thanh toán
    Visa_Card_Number INT, --số thẻ
    Visa_Expiry_Date DATE, --ngày hết hạn
);

--Khoá học được thêm vào đơn hàng
CREATE TABLE Course_Order(
    Course_ID INT,
    Order_ID INT,
    PRIMARY KEY (Course_ID, Order_ID),
);

--Đơn hàng
CREATE TABLE Orders (
    Orders_ID INT PRIMARY KEY,
    Orders_Payment_Status VARCHAR(255),
    Orders_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Payment_ID INT, --mã thanh toán
    Student_ID INT, --mã học viên
);

--Đánh giá
CREATE TABLE Reviews (
    Reviews_ID INT,
    Course_ID INT,
    Reviews_Score INT,
    Reviews_Content TEXT,
    Student_ID INT,
    PRIMARY KEY (Reviews_ID, Course_ID),
)

--Học viên
CREATE TABLE Student(
    Student_ID INT PRIMARY KEY,
    Student_Cart_ID INT,
);

--Người đại diện
CREATE TABLE Guardians(
    Guardians_ID INT,
    Student_ID INT,
    Guardians_Name VARCHAR(255),
    Guardians_Email VARCHAR(255),
    Guardians_Phone_Number INT,
    PRIMARY KEY (Guardians_ID, Student_ID),
)

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
    Admin_ID INT PRIMARY KEY
)