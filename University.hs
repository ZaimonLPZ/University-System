import System.IO
import Data.List

data Student = Student Int Int Int deriving (Show, Read)

loadStudents :: IO [Student]
loadStudents = do
    content <- readFile "University.txt"
    let ls = lines content
    let students= map readStudent ls
    length students `seq` return students

readStudent :: String -> Student
readStudent line =
    let [a,b,c] = map read (words line)
    in Student a b c

saveStudents :: [Student] -> IO ()
saveStudents students =
    writeFile "University.txt" (unlines (map showStudent students))

showStudent :: Student -> String
showStudent (Student i e s) =
    show i ++ " " ++ show e ++ " " ++ show s

printStudent :: Student -> IO ()
printStudent (Student i e s) =
    putStrLn ("Estudiante " ++ show i ++
              " Entro: " ++ show e ++
              " Se abrio: " ++ show s)

checkIn :: Int -> Int -> [Student] -> [Student]
checkIn id time students =
    Student id time 0 : students

searchStudent :: Int -> [Student] -> Maybe Student
searchStudent _ [] = Nothing
searchStudent id (Student i e s : xs)
    | id == i = Just (Student i e s)
    | otherwise = searchStudent id xs

calculateTime :: Student -> Int
calculateTime (Student _ e s) =
    s - e

checkOut :: Int -> Int -> [Student] -> [Student]
checkOut _ _ [] = []
checkOut id time (Student i e s : xs)
    | id == i = Student i e time : checkOut id time xs
    | otherwise = Student i e s : checkOut id time xs

showStudents :: [Student] -> IO ()
showStudents [] = return ()
showStudents (s:xs) = do
    printStudent s
    showStudents xs

menu :: [Student] -> IO ()
menu students = do
    putStrLn "1 Registrar Ingreso"
    putStrLn "2 Buscar Estudiante"
    putStrLn "3 Calcular Tiempo"
    putStrLn "4 Mostrar Estudiantes"
    putStrLn "5 Registrar Salida"
    putStrLn "6 Abrirse del Parche"

    op <- getLine

    case op of
        "1" -> do
            id <- readLn
            t <- readLn
            let ns = checkIn id t students
            saveStudents ns
            menu ns

        "2" -> do
            id <- readLn
            case searchStudent id students of
                Just s -> print s
                Nothing -> putStrLn " No encontrado, Positivo para falso"
            menu students

        "3" -> do
            id <- readLn
            case searchStudent id students of
                Just s -> print (calculateTime s)
                Nothing -> putStrLn "No encontrado, positivo para falso."
            menu students

        "4" -> do
            showStudents students
            menu students

        "5" -> do
            id <- readLn
            t <- readLn
            let ns = checkOut id t students
            saveStudents ns
            menu ns

        "6" -> putStrLn "Pico y chao"

        _ -> menu students

main :: IO ()
main = do
    students <- loadStudents
    menu students
