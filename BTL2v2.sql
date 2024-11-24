


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
)

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
)



