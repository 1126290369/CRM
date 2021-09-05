import com.hwj.crm.settings.dao.UserDao;
import com.hwj.crm.utils.SqlSessionUtil;

public class Test1 {
    public static void main(String[] args) {
        Object o = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
        System.out.println(o);
    }
}
